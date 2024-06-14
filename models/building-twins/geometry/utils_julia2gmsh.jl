using LinearAlgebra, InvertedIndices

function extract_until_comment(s)
    comment_pos = findfirst("//", s)
    if comment_pos !== nothing
        return s[1:prevind(s, comment_pos[1])]
    else
        return s
    end
end

function list_volumes_starting_with(n::Int)
    return join( sort(
        [ℓ for ℓ in keys(SurfaceLoop) if parse(Int, string(ℓ)[1:1])==n]
        ), ", ")
end

"""
Converts a Julia geometry file 'input' (.jl) in the current directory to a Gmsh .geo file with name 'output' (.geo), using either kerenel="occ" or kernel="geo" (default). 
Note, you can execute this function in a directory, say "geometrydir", with the following command:
cd(julia2gmsh("input", "output"), "geometrydir")
"""
function julia2gmsh(input::String, output::String, kernel="geo")
    # https://regexr.com/ is a good resource for regular expressions.
    #-------------------------------------------------------------------------------------------------------------------
    if kernel != "occ" && kernel != "geo"
        error("Error: kernel must be either \"occ\" or \"geo\".")
    end

    file_content = readlines(input) # reads in all the lines of the file
    include(input) # reads in all the variables defined in the file
    lc = 5 # default mesh size

    # REMOVE . . .
    file_content = filter(x -> !occursin(r"Dict", x), file_content) # ... Dict

    # REPLACE . . .
    file_content = replace.(file_content, "#" => "//") # ...comments

    # need to refine this rule: Point( ) = {     }

    rule_left_curly  = x -> replace(x, "[" => "{")
    rule_right_curly = x -> replace(x, "]" => "}")
    file_content = replace.(file_content, r"(?<=\=)[^;]*(?=,)" => rule_left_curly)
    file_content = replace.(file_content, r"(?<=,)[^;]*(?=;)" => rule_right_curly) # ...brackets with curly braces

    rule_left_paren  = x -> replace(x, "[" => "(")
    rule_right_paren = x -> replace(x, "]" => ")")
    file_content = replace.(file_content, r"^(?!\s*//).*" => rule_left_paren)
    file_content = replace.(file_content, r"^(?!\s*//).*" => rule_right_paren) # ...brackets with parentheses

    file_content = replace.(file_content, r"\btan\b\(" => "Tan(") # ...tan
    file_content = replace.(file_content, "atan(" => "Atan(") # ...atan
    file_content = replace.(file_content, "sqrt(" => "Sqrt(") # ...sqrt
    file_content = replace.(file_content, "π" => "Pi") # ...pi
    file_content = replace.(file_content, "CurveLoop" => "Curve Loop") # ...curve loops
    file_content = replace.(file_content, "SurfaceLoop" => "Surface Loop") # ...surface loops

    # ADD . . .
    rule_lc = x -> replace(x, "};" => ", lc};")
    file_content = replace.(file_content, r"^(?!\s*//).*Point.*" => rule_lc) # ...lc

    # Deterimine admissible directions for the Lines (k) comprising each Curve Loop (ℓ).
    if kernel == "geo"
        direction = Dict{Int, Vector{Int}}()
        for ℓ in keys(CurveLoop)
            # global direction
            direction[ℓ] = zeros(Int, length(CurveLoop[ℓ]))
            # first line handling
            if Line[CurveLoop[ℓ][1]][2] ∈ Line[CurveLoop[ℓ][2]]
                direction[ℓ][1] = 1
            elseif Line[CurveLoop[ℓ][1]][1] ∈ Line[CurveLoop[ℓ][2]]
                direction[ℓ][1] = -1
            else
                error("Error: point mismatch in Curve Loop $ℓ, lines $(CurveLoop[ℓ][1]) and $(CurveLoop[ℓ][2]): Points $(Line[CurveLoop[ℓ][1]][2]) ≠ $(Line[CurveLoop[ℓ][2]][1]) or $(Line[CurveLoop[ℓ][1]][2]) ≠ $(Line[CurveLoop[ℓ][2]][2])")
            end
            # rest of the lines
            for m in 1:length(CurveLoop[ℓ])-1
                if direction[ℓ][m]==1
                    if Line[CurveLoop[ℓ][m]][2] == Line[CurveLoop[ℓ][m+1]][1]
                        direction[ℓ][m+1] = 1
                    elseif Line[CurveLoop[ℓ][m]][2] == Line[CurveLoop[ℓ][m+1]][2]
                        direction[ℓ][m+1] = -1
                    else
                        error("Error: point mismatch in Curve Loop $ℓ, lines $(CurveLoop[ℓ][m]) and $(CurveLoop[ℓ][m+1]): Points $(Line[CurveLoop[ℓ][m]][2]) ≠ $(Line[CurveLoop[ℓ][m+1]][1]) or $(Line[CurveLoop[ℓ][m]][2]) ≠ $(Line[CurveLoop[ℓ][m+1]][2])")
                    end
                elseif direction[ℓ][m]==-1
                    if Line[CurveLoop[ℓ][m]][1] == Line[CurveLoop[ℓ][m+1]][1]
                        direction[ℓ][m+1] = 1
                    elseif Line[CurveLoop[ℓ][m]][1] == Line[CurveLoop[ℓ][m+1]][2]
                        direction[ℓ][m+1] = -1
                    else
                        error("Error: point mismatch in Curve Loop $ℓ, lines $(CurveLoop[ℓ][m]) and $(CurveLoop[ℓ][m+1]): Points $(Line[CurveLoop[ℓ][m]][1]) ≠ $(Line[CurveLoop[ℓ][m+1]][2]) or $(Line[CurveLoop[ℓ][m]][1]) ≠ $(Line[CurveLoop[ℓ][m+1]][1])")
                    end
                end
            end
        end

        # correct direction of the lines in the Curve Loops
        for linenumber in eachindex(file_content)
            line = file_content[linenumber]
            uncommented = extract_until_comment(line)
            matches = eachmatch(r"Curve Loop\((\d+)\)", uncommented)
            for match in matches
                ℓ = parse(Int, match.captures[1])
                direct = direction[ℓ]
                loc = match.offset
                if direct[1]==-1
                    str = replace(line[loc:end], r"=\s*{\s*"=>"= {-", count=1)
                    line = string(line[1:loc-1], str)
                end
                for d in direct[2:end]
                    next_comma = findnext(",", line, loc+1)
                    if next_comma !== nothing
                        loc = next_comma[1]
                        if d==-1
                            str = replace(line[loc:end], r",\s*"=>", -", count=1)
                            line = string(line[1:loc-1], str)
                        end
                    end
                end
                file_content[linenumber] = line
            end
        end

        # Determine admissible orientations for the surfaces (ℓ) comprising each Surface Loop (m).
        orientation = Dict{Int, Vector{Int}}()
        for m in keys(SurfaceLoop)
            # global orientation
            orientation[m] = ones(Int, length(SurfaceLoop[m]))
            # check that the first edge of each CurveLoop is oriented opposite the same line appearing in another CurveLoop
            for ℓ ∈ 1:length(SurfaceLoop[m])-1
                S = SurfaceLoop[m][ℓ]
                k = CurveLoop[S][1] # first edge of the ℓ-th CurveLoop (good)
                L = hcat([CurveLoop[SurfaceLoop[m][l]] for l in 1:length(SurfaceLoop[m])]...)
                L[:,ℓ] .= 0
                ind = findall(x -> x==k, L)[1]
                S′ = SurfaceLoop[m][ind[2]]
                if length(ind) > 0
                    sense_of_S = orientation[m][ℓ]*direction[S][1]
                    sense_of_S′ = orientation[m][ind[2]]*direction[S′][ind[1]]
                    if sense_of_S == sense_of_S′
                        orientation[m][ℓ] = -1
                    end
                else
                    error("Error: edge $k of Surface Loop $m, Curve Loop $(SurfaceLoop[m][ℓ]), is not shared with any other Curve Loop of Surface Loop $m!")
                end
            end
            # might need to invert all of orientation[m] if the normals are directed inwards... not sure (doesn't seem to be an issue yet, but that might just be luck)
            # orientation[m] = -1*orientation[m]
        end

        # correct orientation of the surfaces in the Surface Loops
        # do i need to modify for bounding box volumes? probably, but it works regardless!
        for linenumber in eachindex(file_content)
            line = file_content[linenumber]
            uncommented = extract_until_comment(line)
            matches = eachmatch(r"Surface Loop\((\d+)\)", uncommented)
            for match in matches
                m = parse(Int, match.captures[1])
                orient = orientation[m]
                loc = match.offset
                if orient[1]==-1
                    str = replace(line[loc:end], r"=\s*{\s*"=>"= {-", count=1)
                    line = string(line[1:loc-1], str)
                end
                for o in orient[2:end]
                    next_comma = findnext(",", line, loc+1)
                    if next_comma !== nothing
                        loc = next_comma[1]
                        if o==-1
                            str = replace(line[loc:end], r",\s*"=>", -", count=1)
                            line = string(line[1:loc-1], str)
                        end
                    end
                end
                file_content[linenumber] = line
            end
        end
    end # the if kernel == "geo" block

    # ADD . . .
    kernel_string = "SetFactory(\"OpenCASCADE\");"
    if kernel == "geo"
        kernel_string = "// " * kernel_string
    end
    # need to run through filecontent and check for the last instance of regex r"Curve Loop\((\d+)\)", and split the file content at the next line
    file_content = vcat(
    "// Converted from Julia geometry file $(input) to Gmsh by julia2gmsh.jl", 
    kernel_string,
    "lc = $(lc);", 
    file_content[2:end],
    "", # add a blank line; need to put the list of surfaces before the surface loops
    "// List of surfaces, based on curve loops:",
    sort(["Plane Surface($(ℓ)) = {$(ℓ)};" for ℓ in keys(CurveLoop)]), # append Plane Surface list
    "", # add a blank line
    "// List of volumes, based on surface loops:",
    sort(["Volume($(ℓ)) = {$(ℓ)};" for ℓ in keys(SurfaceLoop)]), # append Volume list
    "", # add a blank line
    # ... physical surfaces
    "Physical Surface(\"maxY\") = {802, 902};",
    "Physical Surface(\"minX\") = {804, 904};",
    "Physical Surface(\"minY\") = {806, 906};",
    "Physical Surface(\"maxX\") = {808, 908};",
    "Physical Surface(\"minZ\") = {900};",
    "Physical Surface(\"maxZ\") = {800};",
    "", # add a blank line
    # ... physical volumes
    "Physical Volume(\"interior\") = {$(list_volumes_starting_with(1))};", # all volumes that start with 1
    "Physical Volume(\"envelope\") = {$(list_volumes_starting_with(2))};", # all volumes that start with 2
    "Physical Volume(\"exterior\") = {$(list_volumes_starting_with(8))};", # all volumes that start with 8
    "Physical Volume(\"ground\") = {$(list_volumes_starting_with(9))};",
    ) # all volumes that start with 9

    # ... meshing commands; Transfinite, etc.

    # WRITE
    open(output, "w") do io
        for line in file_content
            write(io, line, "\n")
        end
    end
end 
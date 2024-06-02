using Plots

# construct a 5x5 matrix of plots with the x tile "Parameters" and y tile "Outputs"
# Create a 5x5 grid of subplots
num_p = 4
num_o = 5
p = scatter(legend=false, grid=false, layout=(num_p,num_o), size=200 .*(num_o,num_p)) #1

# give each subplot an xlabel $p_i$ and ylabel $y_j$
for i in 1:num_p
    for j in 1:num_o
        xlabel!(p[i,j], "p$i")
        ylabel!(p[i,j], "y$j")
    end
end
# fill the subplots with random data
for i in 1:num_p
    for j in 1:num_o
        scatter!(p[i,j], rand(10), rand(10))
    end
end
# display the plot
p
# save the figure in the overleaf figures folder
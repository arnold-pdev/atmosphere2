import os
import numpy as np
import matplotlib.pyplot as plt

from pydmd import DMD
from icecream import ic


def parse_openfoam_data(file_path):
    with open(file_path, "r") as file:
        data_started = False
        data_values = []
        for line in file:
            line = line.strip()
            if data_started:
                if line.startswith(");"):  # End of data block
                    break
                try:
                    data_values.append(float(line))
                except ValueError:
                    continue
            elif line.startswith("internalField"):
                data_started = True
    return np.array(data_values)


def load_data(base_path):
    folders = os.listdir(base_path)
    time_steps = sorted(
        [
            int(folder)
            for folder in folders
            if folder.isdigit() and folder not in ["0", "0.orig"]
        ],
        key=int,
    )

    data_matrix = None

    for time_step in time_steps:
        folder_path = os.path.join(base_path, str(time_step))
        file_path = os.path.join(
            folder_path, "T"
        )  # Assuming the data file is named 'T'
        if os.path.exists(file_path):
            data_values = parse_openfoam_data(file_path)
            if data_matrix is None:
                data_matrix = np.zeros((len(data_values), len(time_steps)))
            data_matrix[:, time_steps.index(time_step)] = data_values

    data_matrix = data_matrix[1:, :]
    return np.array(time_steps), data_matrix


def save_data(base_path, data_matrix, time_steps):
    # Ensure the base path exists
    if not os.path.exists(base_path):
        os.makedirs(base_path)

    # Iterate over each column in the data matrix
    for index, time_step in enumerate(time_steps):
        # Create a subfolder for each time step
        folder_path = os.path.join(base_path, str(time_step))
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)

        # Define the file path for the data to be saved
        file_path = os.path.join(
            folder_path, "T"
        )  # Assuming the data should be saved in a file named 'T'

        # Extract the column data from the matrix
        column_data = data_matrix[:, index]

        # Save the data to the file, simulating the original file format
        with open(file_path, "w") as file:
            file.write(
                "FoamFile\n{\n    version     2.0;\n    format      ascii;\n    class       volScalarField;\n    object      T;\n}\n\n"
            )
            file.write("dimensions      [0 0 0 1 0 0 0];\n\n")
            file.write("internalField   nonuniform List<scalar>\n")
            file.write(f"{len(column_data)}\n(\n")
            for value in column_data:
                file.write(f"{value}\n")
            file.write(")\n;\n\n")
            file.write(
                "boundaryField\n{\n    back\n    {\n        type            empty;\n    }\n    ... (and so on for other boundary conditions)\n}\n"
            )
            file.write(
                "// ************************************************************************* //\n"
            )


def save_data_to_folders(base_path, data_matrix, time_steps):
    # Ensure the base path exists
    if not os.path.exists(base_path):
        os.makedirs(base_path)

    # Iterate over each column in the data matrix
    for index, time_step in enumerate(time_steps):
        # Create a subfolder for each time step
        folder_path = os.path.join(base_path, str(time_step))
        if not os.path.exists(folder_path):
            os.makedirs(folder_path)

        # Define the file path for the data to be saved
        file_path = os.path.join(
            folder_path, "T"
        )  # Assuming the data should be saved in a file named 'T'

        # Extract the column data from the matrix
        column_data = data_matrix[:, index]

        # Save the data to the file with the provided OpenFOAM format
        with open(file_path, "w") as file:
            file.write(
                "/*--------------------------------*- C++ -*----------------------------------*\\\n"
            )
            file.write(
                "| =========                 |                                                 |\n"
            )
            file.write(
                "| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |\n"
            )
            file.write(
                "|  \\\\    /   O peration     | Version:  2312                                  |\n"
            )
            file.write(
                "|   \\\\  /    A nd           | Website:  www.openfoam.com                      |\n"
            )
            file.write(
                "|    \\\\/     M anipulation  |                                                 |\n"
            )
            file.write(
                "\\*---------------------------------------------------------------------------*/\n"
            )
            file.write("FoamFile\n{\n")
            file.write("    version     2.0;\n")
            file.write("    format      ascii;\n")
            file.write('    arch        "LSB;label=32;scalar=64";\n')
            file.write(f"    class       volScalarField;\n")
            file.write(f'    location    "{time_step}";\n')
            file.write("    object      T;\n}\n")
            file.write(
                "// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //\n\n"
            )
            file.write("dimensions      [0 0 0 1 0 0 0];\n\n")
            file.write("internalField   nonuniform List<scalar>\n")
            file.write(f"{len(column_data)}\n(\n")
            for value in column_data:
                file.write(f"{value}\n")
            file.write(")\n;\n\n")
            file.write("boundaryField\n{\n")
            file.write("    back\n    {\n        type            empty;\n    }\n")
            file.write(
                "    eastBase\n    {\n        type            fixedValue;\n        value           uniform 300;\n    }\n"
            )
            file.write(
                "    westBase\n    {\n        type            fixedValue;\n        value           uniform 300;\n    }\n"
            )
            file.write(
                "    bottom\n    {\n        type            fixedValue;\n        value           uniform 300;\n    }\n"
            )
            file.write("    front\n    {\n        type            empty;\n    }\n")
            file.write(
                "    eastSlope\n    {\n        type            fixedValue;\n        value           uniform 400;\n    }\n"
            )
            file.write(
                "    eastLedge\n    {\n        type            fixedValue;\n        value           uniform 350;\n    }\n"
            )
            file.write(
                "    westLedge\n    {\n        type            fixedValue;\n        value           uniform 300;\n    }\n"
            )
            file.write(
                "    westSlope\n    {\n        type            fixedValue;\n        value           uniform 300;\n    }\n"
            )
            file.write(
                "    topFace\n    {\n        type            fixedValue;\n        value           uniform 380;\n    }\n"
            )
            file.write("}\n")
            file.write(
                "// ************************************************************************* //\n"
            )


def rel_norm(x, y):
    return np.linalg.norm(x - y) / np.linalg.norm(x)


def solve_svd(data_matrix, svd_rank):
    u, s, v = np.linalg.svd(data_matrix)

    ic(u.shape)
    ic(v.shape)

    u_l = u[:, :svd_rank]
    s_l = s[:svd_rank]
    v_l = v[:svd_rank, :]

    data_matrix_rec = np.matmul(u_l, np.matmul(np.diag(s_l), v_l))
    ic(rel_norm(data_matrix, data_matrix_rec))

    make_plots(
        u_l.T,
        v_l.T,
        data_matrix,
        data_matrix_rec,
        dir_name="svd",
    )
    return data_matrix_rec


def solve_dmd(u, svd_rank):
    dmd = DMD(svd_rank=svd_rank)
    dmd.fit(u)

    ic(rel_norm(u.real, dmd.reconstructed_data.real))

    make_plots(
        dmd.modes.T,
        dmd.dynamics.T,
        u,
        dmd.reconstructed_data,
        dir_name="pydmd",
    )
    return dmd.reconstructed_data


def make_plots(
    modes,
    dynamics,
    orig_data,
    rec_data,
    dir_name="plots",
    path_name="figures",
):
    full_path = os.path.join(path_name, dir_name)
    if not os.path.exists(full_path):
        os.makedirs(full_path)

    for mode in modes:
        plt.plot(mode.real)
        plt.title("Modes")
    plt.savefig(f"{full_path}/modes.png")
    plt.xlabel("z")
    plt.close()

    for dynamic in dynamics:
        plt.plot(dynamic.real)
    plt.savefig(f"{full_path}/dynamics.png")

    fig, axs = plt.subplots(1, 2)
    axs[0].pcolor(orig_data)
    axs[1].pcolor(rec_data.real)
    axs[0].set_title("Original")
    axs[1].set_title("Reconstructed")
    for ax in axs.flat:
        ax.set(xlabel="z", ylabel="t")
    fig.savefig(f"{full_path}/real-matrix.png")
    plt.close(fig)

    fig, ax = plt.subplots()
    pos = ax.pcolor(abs(orig_data - rec_data.real) ** 2)
    fig.colorbar(pos, ax=ax)
    fig.savefig(f"{full_path}/abs-squared-matrix-diff.png")
    plt.close(fig)
    return


def main():
    data_path = "../../models/building-twins/m1of"
    save_path = "../../models/building-twins/m1of-rec"
    svd_rank = 1

    time_steps, data_matrix = load_data(data_path)
    ic(time_steps.shape)
    ic(data_matrix.shape)

    data_matrix_rec_svd = solve_svd(data_matrix, svd_rank)
    data_matrix_rec_dmd = solve_dmd(data_matrix, svd_rank)

    save_data_to_folders(save_path, data_matrix_rec_svd, time_steps)
    return


if __name__ == "__main__":
    main()

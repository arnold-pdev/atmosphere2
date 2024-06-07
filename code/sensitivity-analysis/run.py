import argparse
import subprocess


def modify_boundary_conditions(host_dir, boundary_conditions):
    # Modify boundary conditions if needed (file-based approach)
    # Assuming boundary_conditions is a dictionary {file_path: new_content}
    for file_path, content in boundary_conditions.items():
        full_path = f"{host_dir}/{file_path}"
        with open(full_path, "w") as file:
            file.write(content)


def run_openfoam(
    container_name, host_dir, container_dir, script_name, boundary_conditions
):
    # Ensure host directory exists and prepare it
    # subprocess.run(["mkdir", "-p", host_dir], check=True)

    docker_command = [
        "docker",
        "run",
        "-it",
        "--mount",
        f"type=bind,source={host_dir},target={container_dir}",
        container_name,
        "/bin/bash",
        "-c",
        f"source /usr/lib/openfoam/openfoam/etc/bashrc && cd {container_dir} && ./{script_name}",
    ]

    subprocess.run(docker_command, check=True)


def main():
    parser = argparse.ArgumentParser(description="Run OpenFOAM project in Docker")
    parser.add_argument("container_name", help="Name or tag of the Docker container")
    parser.add_argument("script_name", help="Name or tag of the script to run")

    args = parser.parse_args()

    # container_name = "my-openfoam:latest"
    host_dir = "/home/ilya/github/atmosphere2/models/building-twins"
    container_dir = "/home/foam/openfoam"
    boundary_conditions = {
        "case/system/boundaryConditions": "/* Your boundary condition settings */"
    }

    run_openfoam(
        args.container_name,
        host_dir,
        container_dir,
        args.script_name,
        boundary_conditions,
    )


if __name__ == "__main__":
    main()

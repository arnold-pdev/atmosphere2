import os
import vtk
import numpy as np
import shapely as sh # for geometry
from vtk.util.numpy_support import vtk_to_numpy
from scipy.interpolate import CloughTocher2DInterpolator
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from mpl_toolkits.axes_grid1 import make_axes_locatable

# change directory to the location of import-vtk.py
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# interpolate vtk data on a uniform grid for the purpose of demonstrating convergence

# Define the standard grid:
member_to_meters = 1.67  # length in meters of each member of structure
# horizontal distances to outside of ledges
w1 = 21 * member_to_meters
w2 = 13 * member_to_meters
w3 = 7 * member_to_meters
# horizontal distances to inside of ledges
b0 = 26 * member_to_meters
b1 = 27 * member_to_meters
b2 = 19 * member_to_meters
b3 = 11 * member_to_meters
# height of walls
h0 = 6.38 * member_to_meters
h1 = 3 * np.sqrt(2) * member_to_meters
h2 = 3 * np.sqrt(2) * member_to_meters
h3 = 2.5 * np.sqrt(2) * member_to_meters

z0 = -3.285  #  signed depth of building below ground level
z1 = z0 + h0  #  height level 1 from ground
z2 = z1 + h1  #  height level 2 from ground
z3 = z2 + h2  #  height level 3 from ground
z4 = z3 + h3  #  height level 4 from ground

# create an array of coordinate tuples
uniform_array = np.array([(x, y) for x in np.linspace(-b0/2, b0/2,100) for y in np.linspace(z0, z4, 100)])
uniform_grid = sh.points(uniform_array)
b2_coords = ((b1/2,z0), (b1/2,z1), (w1/2,z2), (b2/2,z2), (w2/2,z3), (b3/2,z3), (w3/2,z4), (-w3/2,z4), (-b3/2,z3), (-w2/2,z3), (-b2/2,z2), (-w1/2,z2), (-b1/2,z1), (-b1/2,z0))
b2_polygon = sh.Polygon(b2_coords)
# use building geometry to define standard grid using shapely "contains" method
standard_grid = uniform_grid[b2_polygon.contains(uniform_grid)]
standard_grid_array = np.array([np.array(point.coords) for point in standard_grid])
standard_x_values = [point[0][0] for point in standard_grid_array]
standard_y_values = [point[0][1] for point in standard_grid_array]
count_standard = np.shape(standard_grid_array)[0]

# make a for loop to iterate over vtk files
folder = "mesh_convergence_test"
vtu_files = [file for file in os.listdir(folder) if file.endswith(".vtu")]

n = np.shape(vtu_files)[0] # number of vtk files
interpolated_temp_arrays = []
for vtu_file in vtu_files:
    # https://stackoverflow.com/questions/58713448/reading-the-position-coordinates-of-nodes-cells-points-from-vtk-files
    reader = vtk.vtkXMLUnstructuredGridReader() #the vtkXMLUnstructuredGridReader is used specifically to read .vtu files
    reader.SetFileName( os.path.join(folder, vtu_file) )
    reader.Update()

    # prepare coordinates from vtk file
    Point_coordinates = reader.GetOutput().GetPoints().GetData()
    numpy_coordinates_3D = vtk_to_numpy(Point_coordinates) # imports as vector of 3-d vectors (x,y,z) => need to convert to 2D
    # convert to 2D points by keeping only those elements for which y=0
    unique_ids = numpy_coordinates_3D[:, 1] == 0
    numpy_coordinates_3D_unique = numpy_coordinates_3D[unique_ids]
    # ... and remove the y-coordinate
    numpy_coordinates_2D = np.delete(numpy_coordinates_3D_unique, 1, 1) # remove y-coordinate

    # prepare temperature values from vtk file
    temp_array = reader.GetOutput().GetPointData().GetArray("T")
    temp_array = vtk_to_numpy(temp_array)[unique_ids]

    # convert standard grid to numpy array
    vtk_interpolator = CloughTocher2DInterpolator(numpy_coordinates_2D, temp_array) 
    interpolated_temp_array = vtk_interpolator(standard_grid_array).flatten()
    interpolated_temp_arrays.append(interpolated_temp_array)

# take the difference between the interpolated temperature arrays
temp_diff_arrays = []
temp_diff_arrays.append(interpolated_temp_arrays[0] - interpolated_temp_arrays[2]) #1/2 - 1/4
temp_diff_arrays.append(interpolated_temp_arrays[1] - interpolated_temp_arrays[2]) #1 - 1/4
temp_diff_arrays.append(interpolated_temp_arrays[1] - interpolated_temp_arrays[0]) #1 - 1/2

# Load the images
img1 = mpimg.imread('g1_p1_1.png')
img2 = mpimg.imread('g1_p025_p25.png')
img3 = mpimg.imread('g1_p05_p5.png')

# Create a 2x3 grid of plots
fig, axs = plt.subplots(2, 3, figsize=(15, 10))

# Display the external images in the respective subplots
axs[0, 0].imshow(img1)
axs[0, 2].imshow(img2)
axs[1, 1].imshow(img3)

mesh_lengths = [1, 0.25, 0.5]
# Remove axis ticks and labels for the images
i = 0
nums = [1, 3, 2]
for ax in [axs[0, 0], axs[0, 2], axs[1, 1]]:
    ax.set_xticks([])
    ax.set_yticks([])
    # Add a secondary title above the plot
    ax.set_title("Grid " + rf"$G_{nums[i]}$", fontsize=16)
    # Add titles inside the subplot near the bottom for the images
    ax.text(0.5, 0.02, "Mesh length scale = " + str(mesh_lengths[i]) + "m", ha='center', va='bottom', transform=ax.transAxes, fontsize=14, bbox=dict(facecolor='white', alpha=0.7, edgecolor='none'))
    i += 1

# Manually set the colorbar limits for consistency across plots
vmin = -2.5  # Example minimum value for the colorbar
vmax = 2.5   # Example maximum value for the colorbar

colormap = 'bwr'

# Extract the polygon coordinates
x_poly, y_poly = b2_polygon.exterior.xy

rmses = []
max_abs_diffs = []
locs = [(1, 2), (0, 1), (1, 0)]
nums1 = [2, 1, 1]
nums2 = [3, 3, 2]
scatter_plots = []
for i in range(3):
    rmse_unnormed = np.linalg.norm(temp_diff_arrays[i])
    rmse = rmse_unnormed / count_standard
    rmses.append(rmse)
    max_abs_diff = np.max(np.abs(temp_diff_arrays[i]))
    max_abs_diffs.append(max_abs_diff)
    sc = axs[locs[i]].scatter(standard_x_values, standard_y_values, c=temp_diff_arrays[i], s=5, vmin=vmin, vmax=vmax, cmap=colormap)
    scatter_plots.append(sc)  # Store scatter plot objects for consistent color scaling
    
    # Maintain aspect ratio
    axs[locs[i]].set_aspect('equal')
    
    # Plot the polygon on top of the scatter plot
    axs[locs[i]].plot(x_poly, y_poly, color='black', linewidth=1.5)
    
    # Remove axis ticks and labels
    axs[locs[i]].set_xticks([])
    axs[locs[i]].set_yticks([])

    # Add a secondary title above the plot
    axs[locs[i]].set_title("Temp Difference " + rf"$\Delta T = T(G_{nums1[i]})-T(G_{nums2[i]})$", fontsize=16)
    
    # Move the title inside the subplot near the bottom
    axs[locs[i]].text(0.5, 0.02, r"$\frac{\left[\int_\mathcal{D}(\Delta T)^2 dx\right]^{1/2}}{\int_\mathcal{D}dx}\approx$" + f"{rmse:.5f} °C", ha='center', va='bottom', transform=axs[locs[i]].transAxes, fontsize=14, bbox=dict(facecolor='white', alpha=0.7, edgecolor='none'))

# Adjust layout to make space on the right for the colorbar # and reduce vertical gap
fig.subplots_adjust(right=0.85)

# Add a single vertical colorbar to the right of all subplots
cbar_ax = fig.add_axes([0.87, 0.15, 0.03, 0.7])  # [left, bottom, width, height]
cbar = fig.colorbar(scatter_plots[0], cax=cbar_ax)

# Set the same color limits for all scatter plots
for sc in scatter_plots:
    sc.set_clim(vmin, vmax)

# Label the colorbar
cbar.set_label('Temperature Difference (°C)', fontsize=16)

# Adjust layout to fit everything nicely
plt.tight_layout(rect=[0, 0, 0.85, 1], pad=0.5, h_pad=0)

# Save the plot
plt.savefig("convergence-study.png", dpi=300)
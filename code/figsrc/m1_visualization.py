# state file generated using paraview version 5.12.0-RC1
import paraview
paraview.compatibility.major = 5
paraview.compatibility.minor = 12

#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# ----------------------------------------------------------------
# setup views used in the visualization
# ----------------------------------------------------------------

# Create a new 'Line Chart View'
lineChartView1 = CreateView('XYChartView')
lineChartView1.ViewSize = [668, 380]
lineChartView1.LegendPosition = [528, 307]
lineChartView1.LeftAxisRangeMinimum = -10.0
lineChartView1.LeftAxisRangeMaximum = 10.0
lineChartView1.BottomAxisRangeMaximum = 50.0
lineChartView1.RightAxisRangeMaximum = 6.66
lineChartView1.TopAxisRangeMaximum = 6.66

# Create a new 'Line Chart View'
lineChartView2 = CreateView('XYChartView')
lineChartView2.ViewSize = [668, 378]
lineChartView2.LegendPosition = [642, 335]
lineChartView2.LeftAxisRangeMinimum = 285.0
lineChartView2.LeftAxisRangeMaximum = 315.0
lineChartView2.BottomAxisRangeMaximum = 50.0
lineChartView2.RightAxisRangeMaximum = 6.66
lineChartView2.TopAxisRangeMaximum = 6.66

# get the material library
materialLibrary1 = GetMaterialLibrary()

# Create a new 'Render View'
renderView1 = CreateView('RenderView')
renderView1.ViewSize = [670, 836]
renderView1.AxesGrid = 'Grid Axes 3D Actor'
renderView1.CenterOfRotation = [-1.8930988311767578, 0.5, 9.861677408218384]
renderView1.StereoType = 'Crystal Eyes'
renderView1.CameraPosition = [-1.934479969526624, -145.05641142595437, 11.590817832123854]
renderView1.CameraFocalPoint = [-1.934479969526624, 0.5, 11.590817832123854]
renderView1.CameraViewUp = [0.0, 0.0, 1.0]
renderView1.CameraFocalDisk = 1.0
renderView1.CameraParallelScale = 38.012860959011086
renderView1.LegendGrid = 'Legend Grid Actor'
renderView1.BackEnd = 'OSPRay raycaster'
renderView1.OSPRayMaterialLibrary = materialLibrary1

SetActiveView(None)

# ----------------------------------------------------------------
# setup view layouts
# ----------------------------------------------------------------

# create new layout object 'Layout #1'
layout1 = CreateLayout(name='Layout #1')
layout1.SplitHorizontal(0, 0.500000)
layout1.AssignView(1, renderView1)
layout1.SplitVertical(2, 0.500000)
layout1.AssignView(5, lineChartView1)
layout1.AssignView(6, lineChartView2)
layout1.SetSize(1339, 836)

# ----------------------------------------------------------------
# restore active view
SetActiveView(renderView1)
# ----------------------------------------------------------------

# ----------------------------------------------------------------
# setup the data processing pipelines
# ----------------------------------------------------------------

# create a new 'XML MultiBlock Data Reader'
openfoamvtmseries = XMLMultiBlockDataReader(registrationName='openfoam.vtm.series', FileName=['/Users/arnold/PROJECTS/a2/a2_main/models/building-twins/m1_bcs/VTK_06-06-2024_23.28.55/openfoam.vtm.series'])
openfoamvtmseries.CellArrayStatus = ['T', 'p', 'U']
openfoamvtmseries.PointArrayStatus = ['T', 'p', 'U']

# create a new 'Plot Over Line'
plotOverLine1 = PlotOverLine(registrationName='PlotOverLine1', Input=openfoamvtmseries)
plotOverLine1.Point1 = [-23.0, 0.0, -3.2850000858306885]
plotOverLine1.Point2 = [23.0, 0.0, -3.2850000858306885]

# create a new 'Glyph'
glyph2 = Glyph(registrationName='Glyph2', Input=openfoamvtmseries,
    GlyphType='Arrow')
glyph2.OrientationArray = ['POINTS', 'U']
glyph2.ScaleArray = ['POINTS', 'U']
glyph2.ScaleFactor = 0.276
glyph2.GlyphTransform = 'Transform2'

# ----------------------------------------------------------------
# setup the visualization in view 'lineChartView1'
# ----------------------------------------------------------------

# show data from plotOverLine1
plotOverLine1Display = Show(plotOverLine1, lineChartView1, 'XYChartRepresentation')

# trace defaults for the display properties.
plotOverLine1Display.UseIndexForXAxis = 0
plotOverLine1Display.XArrayName = 'arc_length'
plotOverLine1Display.SeriesVisibility = ['U_X', 'U_Z']
plotOverLine1Display.SeriesLabel = ['arc_length', 'arc_length', 'p', 'p', 'T', 'T', 'U_X', 'U_X', 'U_Y', 'U_Y', 'U_Z', 'U_Z', 'U_Magnitude', 'U_Magnitude', 'vtkValidPointMask', 'vtkValidPointMask', 'Points_X', 'Points_X', 'Points_Y', 'Points_Y', 'Points_Z', 'Points_Z', 'Points_Magnitude', 'Points_Magnitude']
plotOverLine1Display.SeriesColor = ['arc_length', '0', '0', '0', 'p', '0.8899977111467154', '0.10000762951094835', '0.1100022888532845', 'T', '0.220004577706569', '0.4899977111467155', '0.7199969481956207', 'U_X', '0.30000762951094834', '0.6899977111467155', '0.2899977111467155', 'U_Y', '0.6', '0.3100022888532845', '0.6399938963912413', 'U_Z', '1', '0.5000076295109483', '0', 'U_Magnitude', '0.6500038147554742', '0.3400015259021897', '0.16000610360875867', 'vtkValidPointMask', '0', '0', '0', 'Points_X', '0.8899977111467154', '0.10000762951094835', '0.1100022888532845', 'Points_Y', '0.220004577706569', '0.4899977111467155', '0.7199969481956207', 'Points_Z', '0.30000762951094834', '0.6899977111467155', '0.2899977111467155', 'Points_Magnitude', '0.6', '0.3100022888532845', '0.6399938963912413']
plotOverLine1Display.SeriesOpacity = ['arc_length', '1', 'p', '1', 'T', '1', 'U_X', '1', 'U_Y', '1', 'U_Z', '1', 'U_Magnitude', '1', 'vtkValidPointMask', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'Points_Magnitude', '1']
plotOverLine1Display.SeriesPlotCorner = ['Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'T', '0', 'U_Magnitude', '0', 'U_X', '0', 'U_Y', '0', 'U_Z', '0', 'arc_length', '0', 'p', '0', 'vtkValidPointMask', '0']
plotOverLine1Display.SeriesLabelPrefix = ''
plotOverLine1Display.SeriesLineStyle = ['Points_Magnitude', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'T', '1', 'U_Magnitude', '1', 'U_X', '1', 'U_Y', '1', 'U_Z', '1', 'arc_length', '1', 'p', '1', 'vtkValidPointMask', '1']
plotOverLine1Display.SeriesLineThickness = ['Points_Magnitude', '2', 'Points_X', '2', 'Points_Y', '2', 'Points_Z', '2', 'T', '2', 'U_Magnitude', '2', 'U_X', '2', 'U_Y', '2', 'U_Z', '2', 'arc_length', '2', 'p', '2', 'vtkValidPointMask', '2']
plotOverLine1Display.SeriesMarkerStyle = ['Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'T', '0', 'U_Magnitude', '0', 'U_X', '0', 'U_Y', '0', 'U_Z', '0', 'arc_length', '0', 'p', '0', 'vtkValidPointMask', '0']
plotOverLine1Display.SeriesMarkerSize = ['Points_Magnitude', '4', 'Points_X', '4', 'Points_Y', '4', 'Points_Z', '4', 'T', '4', 'U_Magnitude', '4', 'U_X', '4', 'U_Y', '4', 'U_Z', '4', 'arc_length', '4', 'p', '4', 'vtkValidPointMask', '4']

# ----------------------------------------------------------------
# setup the visualization in view 'lineChartView2'
# ----------------------------------------------------------------

# show data from plotOverLine1
plotOverLine1Display_1 = Show(plotOverLine1, lineChartView2, 'XYChartRepresentation')

# trace defaults for the display properties.
plotOverLine1Display_1.UseIndexForXAxis = 0
plotOverLine1Display_1.XArrayName = 'arc_length'
plotOverLine1Display_1.SeriesVisibility = ['T']
plotOverLine1Display_1.SeriesLabel = ['arc_length', 'arc_length', 'p', 'p', 'T', 'T', 'U_X', 'U_X', 'U_Y', 'U_Y', 'U_Z', 'U_Z', 'U_Magnitude', 'U_Magnitude', 'vtkValidPointMask', 'vtkValidPointMask', 'Points_X', 'Points_X', 'Points_Y', 'Points_Y', 'Points_Z', 'Points_Z', 'Points_Magnitude', 'Points_Magnitude']
plotOverLine1Display_1.SeriesColor = ['arc_length', '0', '0', '0', 'p', '0.8899977111467154', '0.10000762951094835', '0.1100022888532845', 'T', '0.220004577706569', '0.4899977111467155', '0.7199969481956207', 'U_X', '0.30000762951094834', '0.6899977111467155', '0.2899977111467155', 'U_Y', '0.6', '0.3100022888532845', '0.6399938963912413', 'U_Z', '1', '0.5000076295109483', '0', 'U_Magnitude', '0.6500038147554742', '0.3400015259021897', '0.16000610360875867', 'vtkValidPointMask', '0', '0', '0', 'Points_X', '0.8899977111467154', '0.10000762951094835', '0.1100022888532845', 'Points_Y', '0.220004577706569', '0.4899977111467155', '0.7199969481956207', 'Points_Z', '0.30000762951094834', '0.6899977111467155', '0.2899977111467155', 'Points_Magnitude', '0.6', '0.3100022888532845', '0.6399938963912413']
plotOverLine1Display_1.SeriesOpacity = ['arc_length', '1', 'p', '1', 'T', '1', 'U_X', '1', 'U_Y', '1', 'U_Z', '1', 'U_Magnitude', '1', 'vtkValidPointMask', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'Points_Magnitude', '1']
plotOverLine1Display_1.SeriesPlotCorner = ['Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'T', '0', 'U_Magnitude', '0', 'U_X', '0', 'U_Y', '0', 'U_Z', '0', 'arc_length', '0', 'p', '0', 'vtkValidPointMask', '0']
plotOverLine1Display_1.SeriesLabelPrefix = ''
plotOverLine1Display_1.SeriesLineStyle = ['Points_Magnitude', '1', 'Points_X', '1', 'Points_Y', '1', 'Points_Z', '1', 'T', '1', 'U_Magnitude', '1', 'U_X', '1', 'U_Y', '1', 'U_Z', '1', 'arc_length', '1', 'p', '1', 'vtkValidPointMask', '1']
plotOverLine1Display_1.SeriesLineThickness = ['Points_Magnitude', '2', 'Points_X', '2', 'Points_Y', '2', 'Points_Z', '2', 'T', '2', 'U_Magnitude', '2', 'U_X', '2', 'U_Y', '2', 'U_Z', '2', 'arc_length', '2', 'p', '2', 'vtkValidPointMask', '2']
plotOverLine1Display_1.SeriesMarkerStyle = ['Points_Magnitude', '0', 'Points_X', '0', 'Points_Y', '0', 'Points_Z', '0', 'T', '0', 'U_Magnitude', '0', 'U_X', '0', 'U_Y', '0', 'U_Z', '0', 'arc_length', '0', 'p', '0', 'vtkValidPointMask', '0']
plotOverLine1Display_1.SeriesMarkerSize = ['Points_Magnitude', '4', 'Points_X', '4', 'Points_Y', '4', 'Points_Z', '4', 'T', '4', 'U_Magnitude', '4', 'U_X', '4', 'U_Y', '4', 'U_Z', '4', 'arc_length', '4', 'p', '4', 'vtkValidPointMask', '4']

# ----------------------------------------------------------------
# setup the visualization in view 'renderView1'
# ----------------------------------------------------------------

# show data from openfoamvtmseries
openfoamvtmseriesDisplay = Show(openfoamvtmseries, renderView1, 'GeometryRepresentation')

# get 2D transfer function for 'T'
tTF2D = GetTransferFunction2D('T')
tTF2D.ScalarRangeInitialized = 1
tTF2D.Range = [250.0, 400.0, 197.14075684547424, 400.0]

# get color transfer function/color map for 'T'
tLUT = GetColorTransferFunction('T')
tLUT.AutomaticRescaleRangeMode = 'Never'
tLUT.TransferFunction2D = tTF2D
tLUT.RGBPoints = [250.0, 0.231373, 0.298039, 0.752941, 324.99996229725446, 0.865003, 0.865003, 0.865003, 400.0, 0.705882, 0.0156863, 0.14902]
tLUT.ScalarRangeInitialized = 1.0

# trace defaults for the display properties.
openfoamvtmseriesDisplay.Representation = 'Surface'
openfoamvtmseriesDisplay.ColorArrayName = ['POINTS', 'T']
openfoamvtmseriesDisplay.LookupTable = tLUT
openfoamvtmseriesDisplay.SelectTCoordArray = 'None'
openfoamvtmseriesDisplay.SelectNormalArray = 'None'
openfoamvtmseriesDisplay.SelectTangentArray = 'None'
openfoamvtmseriesDisplay.OSPRayScaleArray = 'T'
openfoamvtmseriesDisplay.OSPRayScaleFunction = 'Piecewise Function'
openfoamvtmseriesDisplay.Assembly = 'Hierarchy'
openfoamvtmseriesDisplay.SelectOrientationVectors = 'None'
openfoamvtmseriesDisplay.ScaleFactor = 4.6000000000000005
openfoamvtmseriesDisplay.SelectScaleArray = 'None'
openfoamvtmseriesDisplay.GlyphType = 'Arrow'
openfoamvtmseriesDisplay.GlyphTableIndexArray = 'None'
openfoamvtmseriesDisplay.GaussianRadius = 0.23
openfoamvtmseriesDisplay.SetScaleArray = ['POINTS', 'T']
openfoamvtmseriesDisplay.ScaleTransferFunction = 'Piecewise Function'
openfoamvtmseriesDisplay.OpacityArray = ['POINTS', 'T']
openfoamvtmseriesDisplay.OpacityTransferFunction = 'Piecewise Function'
openfoamvtmseriesDisplay.DataAxesGrid = 'Grid Axes Representation'
openfoamvtmseriesDisplay.PolarAxes = 'Polar Axes Representation'
openfoamvtmseriesDisplay.SelectInputVectors = ['POINTS', 'U']
openfoamvtmseriesDisplay.WriteLog = ''

# init the 'Piecewise Function' selected for 'ScaleTransferFunction'
openfoamvtmseriesDisplay.ScaleTransferFunction.Points = [300.0, 0.0, 0.5, 0.0, 400.0, 1.0, 0.5, 0.0]

# init the 'Piecewise Function' selected for 'OpacityTransferFunction'
openfoamvtmseriesDisplay.OpacityTransferFunction.Points = [300.0, 0.0, 0.5, 0.0, 400.0, 1.0, 0.5, 0.0]

# show data from glyph2
glyph2Display = Show(glyph2, renderView1, 'GeometryRepresentation')

# get 2D transfer function for 'U'
uTF2D = GetTransferFunction2D('U')

# get color transfer function/color map for 'U'
uLUT = GetColorTransferFunction('U')
uLUT.TransferFunction2D = uTF2D
uLUT.RGBPoints = [0.0, 0.001462, 0.000466, 0.013866, 0.21378285515841858, 0.002267, 0.00127, 0.01857, 0.42751120168472123, 0.003299, 0.002249, 0.024239, 0.6412940568431398, 0.004547, 0.003392, 0.030909, 0.8550224033694425, 0.006006, 0.004692, 0.038558, 1.0688052585278611, 0.007676, 0.006136, 0.046836, 1.2825336050541638, 0.009561, 0.007713, 0.055143, 1.4963164602125822, 0.011663, 0.009417, 0.06346, 1.710099315371001, 0.013995, 0.011225, 0.071862, 1.9238276618973036, 0.016561, 0.013136, 0.080282, 2.1376105170557222, 0.019373, 0.015133, 0.088767, 2.351338863582025, 0.022447, 0.017199, 0.097327, 2.565121718740443, 0.025793, 0.019331, 0.10593, 2.778850065266746, 0.029432, 0.021503, 0.114621, 2.9926329204251645, 0.033385, 0.023702, 0.123397, 3.2064157755835834, 0.037668, 0.025921, 0.132232, 3.420144122109886, 0.042253, 0.028139, 0.141141, 3.6339269772683047, 0.046915, 0.030324, 0.150164, 3.847655323794607, 0.051644, 0.032474, 0.159254, 4.0614381789530265, 0.056449, 0.034569, 0.168414, 4.275166525479329, 0.06134, 0.03659, 0.177642, 4.488949380637747, 0.066331, 0.038504, 0.186962, 4.702732235796166, 0.071429, 0.040294, 0.196354, 4.916460582322468, 0.076637, 0.041905, 0.205799, 5.130243437480886, 0.081962, 0.043328, 0.215289, 5.34397178400719, 0.087411, 0.044556, 0.224813, 5.557754639165608, 0.09299, 0.045583, 0.234358, 5.771482985691911, 0.098702, 0.046402, 0.243904, 5.985265840850329, 0.104551, 0.047008, 0.25343, 6.198994187376632, 0.110536, 0.047399, 0.262912, 6.412777042535051, 0.116656, 0.047574, 0.272321, 6.626559897693469, 0.122908, 0.047536, 0.281624, 6.840288244219772, 0.129285, 0.047293, 0.290788, 7.0540710993781905, 0.135778, 0.046856, 0.299776, 7.267799445904494, 0.142378, 0.046242, 0.308553, 7.481582301062911, 0.149073, 0.045468, 0.317085, 7.695310647589214, 0.15585, 0.044559, 0.325338, 7.909093502747633, 0.162689, 0.043554, 0.333277, 8.122876357906053, 0.169575, 0.042489, 0.340874, 8.336604704432354, 0.176493, 0.041402, 0.348111, 8.550387559590773, 0.183429, 0.040329, 0.354971, 8.764115906117077, 0.190367, 0.039309, 0.361447, 8.977898761275494, 0.197297, 0.0384, 0.367535, 9.191627107801796, 0.204209, 0.037632, 0.373238, 9.405409962960215, 0.211095, 0.03703, 0.378563, 9.619192818118634, 0.217949, 0.036615, 0.383522, 9.832921164644937, 0.224763, 0.036405, 0.388129, 10.046704019803355, 0.231538, 0.036405, 0.3924, 10.260432366329658, 0.238273, 0.036621, 0.396353, 10.474215221488077, 0.244967, 0.037055, 0.400007, 10.68794356801438, 0.25162, 0.037705, 0.403378, 10.901726423172798, 0.258234, 0.038571, 0.406485, 11.115509278331215, 0.26481, 0.039647, 0.409345, 11.32923762485752, 0.271347, 0.040922, 0.411976, 11.543020480015938, 0.27785, 0.042353, 0.414392, 11.756748826542239, 0.284321, 0.043933, 0.416608, 11.970531681700658, 0.290763, 0.045644, 0.418637, 12.184260028226962, 0.297178, 0.04747, 0.420491, 12.39804288338538, 0.303568, 0.049396, 0.422182, 12.611825738543798, 0.309935, 0.051407, 0.423721, 12.825554085070102, 0.316282, 0.05349, 0.425116, 13.039336940228521, 0.32261, 0.055634, 0.426377, 13.253065286754822, 0.328921, 0.057827, 0.427511, 13.46684814191324, 0.335217, 0.06006, 0.428524, 13.680576488439543, 0.3415, 0.062325, 0.429425, 13.894359343597964, 0.347771, 0.064616, 0.430217, 14.108142198756381, 0.354032, 0.066925, 0.430906, 14.321870545282684, 0.360284, 0.069247, 0.431497, 14.535653400441102, 0.366529, 0.071579, 0.431994, 14.749381746967405, 0.372768, 0.073915, 0.4324, 14.963164602125822, 0.379001, 0.076253, 0.432719, 15.176892948652126, 0.385228, 0.078591, 0.432955, 15.390675803810547, 0.391453, 0.080927, 0.433109, 15.604458658968964, 0.397674, 0.083257, 0.433183, 15.818187005495266, 0.403894, 0.08558, 0.433179, 16.031969860653685, 0.410113, 0.087896, 0.433098, 16.245698207179988, 0.416331, 0.090203, 0.432943, 16.459481062338405, 0.422549, 0.092501, 0.432714, 16.673209408864707, 0.428768, 0.09479, 0.432412, 16.886992264023128, 0.434987, 0.097069, 0.432039, 17.100720610549427, 0.441207, 0.099338, 0.431594, 17.314503465707848, 0.447428, 0.101597, 0.43108, 17.52828632086627, 0.453651, 0.103848, 0.430498, 17.74201466739257, 0.459875, 0.106089, 0.429846, 17.955797522550988, 0.4661, 0.108322, 0.429125, 18.16952586907729, 0.472328, 0.110547, 0.428334, 18.38330872423571, 0.478558, 0.112764, 0.427475, 18.59703707076201, 0.484789, 0.114974, 0.426548, 18.81081992592043, 0.491022, 0.117179, 0.425552, 19.024602781078848, 0.497257, 0.119379, 0.424488, 19.238331127605154, 0.503493, 0.121575, 0.423356, 19.45211398276357, 0.50973, 0.123769, 0.422156, 19.665842329289873, 0.515967, 0.12596, 0.420887, 19.87962518444829, 0.522206, 0.12815, 0.419549, 20.093353530974593, 0.528444, 0.130341, 0.418142, 20.307136386133013, 0.534683, 0.132534, 0.416667, 20.52091924129143, 0.54092, 0.134729, 0.415123, 20.734647587817737, 0.547157, 0.136929, 0.413511, 20.948430442976154, 0.553392, 0.139134, 0.411829, 21.162158789502456, 0.559624, 0.141346, 0.410078, 21.375941644660873, 0.565854, 0.143567, 0.408258, 21.589669991187176, 0.572081, 0.145797, 0.406369, 21.803452846345596, 0.578304, 0.148039, 0.404411, 22.017235701504013, 0.584521, 0.150294, 0.402385, 22.230964048030316, 0.590734, 0.152563, 0.40029, 22.444746903188737, 0.59694, 0.154848, 0.398125, 22.65847524971504, 0.603139, 0.157151, 0.395891, 22.872258104873456, 0.60933, 0.159474, 0.393589, 23.08598645139976, 0.615513, 0.161817, 0.391219, 23.29976930655818, 0.621685, 0.164184, 0.388781, 23.513552161716596, 0.627847, 0.166575, 0.386276, 23.7272805082429, 0.633998, 0.168992, 0.383704, 23.941063363401316, 0.640135, 0.171438, 0.381065, 24.154791709927622, 0.64626, 0.173914, 0.378359, 24.36857456508604, 0.652369, 0.176421, 0.375586, 24.58230291161234, 0.658463, 0.178962, 0.372748, 24.79608576677076, 0.66454, 0.181539, 0.369846, 25.00986862192918, 0.670599, 0.184153, 0.366879, 25.22359696845548, 0.676638, 0.186807, 0.363849, 25.4373798236139, 0.682656, 0.189501, 0.360757, 25.651108170140205, 0.688653, 0.192239, 0.357603, 25.864891025298622, 0.694627, 0.195021, 0.354388, 26.078619371824924, 0.700576, 0.197851, 0.351113, 26.29240222698334, 0.7065, 0.200728, 0.347777, 26.506185082141762, 0.712396, 0.203656, 0.344383, 26.719913428668065, 0.718264, 0.206636, 0.340931, 26.93369628382648, 0.724103, 0.20967, 0.337424, 27.147424630352784, 0.729909, 0.212759, 0.333861, 27.361207485511205, 0.735683, 0.215906, 0.330245, 27.57493583203751, 0.741423, 0.219112, 0.326576, 27.788718687195928, 0.747127, 0.222378, 0.322856, 28.002447033722227, 0.752794, 0.225706, 0.319085, 28.216229888880644, 0.758422, 0.229097, 0.315266, 28.43001274403906, 0.76401, 0.232554, 0.311399, 28.643741090565367, 0.769556, 0.236077, 0.307485, 28.857523945723784, 0.775059, 0.239667, 0.303526, 29.071252292250087, 0.780517, 0.243327, 0.299523, 29.28503514740851, 0.785929, 0.247056, 0.295477, 29.49876349393481, 0.791293, 0.250856, 0.29139, 29.712546349093227, 0.796607, 0.254728, 0.287264, 29.926329204251644, 0.801871, 0.258674, 0.283099, 30.14005755077795, 0.807082, 0.262692, 0.278898, 30.353840405936367, 0.812239, 0.266786, 0.274661, 30.56756875246267, 0.817341, 0.270954, 0.27039, 30.781351607621094, 0.822386, 0.275197, 0.266085, 30.995079954147393, 0.827372, 0.279517, 0.26175, 31.20886280930581, 0.832299, 0.283913, 0.257383, 31.422645664464227, 0.837165, 0.288385, 0.252988, 31.636374010990533, 0.841969, 0.292933, 0.248564, 31.85015686614895, 0.846709, 0.297559, 0.244113, 32.06388521267525, 0.851384, 0.30226, 0.239636, 32.27766806783367, 0.855992, 0.307038, 0.235133, 32.491396414359976, 0.860533, 0.311892, 0.230606, 32.70517926951839, 0.865006, 0.316822, 0.226055, 32.91896212467681, 0.869409, 0.321827, 0.221482, 33.13269047120312, 0.873741, 0.326906, 0.216886, 33.34647332636153, 0.878001, 0.33206, 0.212268, 33.560201672887835, 0.882188, 0.337287, 0.207628, 33.773984528046256, 0.886302, 0.342586, 0.202968, 33.98771287457256, 0.890341, 0.347957, 0.198286, 34.20149572973097, 0.894305, 0.353399, 0.193584, 34.41527858488939, 0.898192, 0.358911, 0.18886, 34.629006931415695, 0.902003, 0.364492, 0.184116, 34.842789786574116, 0.905735, 0.37014, 0.17935, 35.05651813310042, 0.90939, 0.375856, 0.174563, 35.27030098825884, 0.912966, 0.381636, 0.169755, 35.48402933478514, 0.916462, 0.387481, 0.164924, 35.697812189943555, 0.919879, 0.393389, 0.16007, 35.911595045101976, 0.923215, 0.399359, 0.155193, 36.12532339162828, 0.92647, 0.405389, 0.150292, 36.3391062467867, 0.929644, 0.411479, 0.145367, 36.552834593313, 0.932737, 0.417627, 0.140417, 36.76661744847142, 0.935747, 0.423831, 0.13544, 36.980345794997724, 0.938675, 0.430091, 0.130438, 37.19412865015614, 0.941521, 0.436405, 0.125409, 37.40791150531456, 0.944285, 0.442772, 0.120354, 37.62163985184086, 0.946965, 0.449191, 0.115272, 37.83542270699928, 0.949562, 0.45566, 0.110164, 38.049151053525584, 0.952075, 0.462178, 0.105031, 38.262933908684, 0.954506, 0.468744, 0.099874, 38.47666225521031, 0.956852, 0.475356, 0.094695, 38.69044511036872, 0.959114, 0.482014, 0.089499, 38.90417345689503, 0.961293, 0.488716, 0.084289, 39.117956312053444, 0.963387, 0.495462, 0.079073, 39.331739167211865, 0.965397, 0.502249, 0.073859, 39.54546751373817, 0.967322, 0.509078, 0.068659, 39.75925036889658, 0.969163, 0.515946, 0.063488, 39.97297871542289, 0.970919, 0.522853, 0.058367, 40.186761570581304, 0.97259, 0.529798, 0.053324, 40.400489917107606, 0.974176, 0.53678, 0.048392, 40.61427277226603, 0.975677, 0.543798, 0.043618, 40.82805562742445, 0.977092, 0.55085, 0.03905, 41.04178397395074, 0.978422, 0.557937, 0.034931, 41.25556682910916, 0.979666, 0.565057, 0.031409, 41.46929517563547, 0.980824, 0.572209, 0.028508, 41.68307803079389, 0.981895, 0.579392, 0.02625, 41.89680637732019, 0.982881, 0.586606, 0.024661, 42.11058923247861, 0.983779, 0.593849, 0.02377, 42.32437208763703, 0.984591, 0.601122, 0.023606, 42.538100434163326, 0.985315, 0.608422, 0.024202, 42.751883289321746, 0.985952, 0.61575, 0.025592, 42.965611635848056, 0.986502, 0.623105, 0.027814, 43.17939449100647, 0.986964, 0.630485, 0.030908, 43.39312283753277, 0.987337, 0.63789, 0.034916, 43.60690569269119, 0.987622, 0.64532, 0.039886, 43.82068854784961, 0.987819, 0.652773, 0.045581, 44.03441689437591, 0.987926, 0.66025, 0.05175, 44.24819974953433, 0.987945, 0.667748, 0.058329, 44.46192809606063, 0.987874, 0.675267, 0.065257, 44.67571095121905, 0.987714, 0.682807, 0.072489, 44.889439297745355, 0.987464, 0.690366, 0.07999, 45.103222152903776, 0.987124, 0.697944, 0.087731, 45.317005008062196, 0.986694, 0.70554, 0.095694, 45.53073335458849, 0.986175, 0.713153, 0.103863, 45.74451620974691, 0.985566, 0.720782, 0.112229, 45.958244556273215, 0.984865, 0.728427, 0.120785, 46.172027411431635, 0.984075, 0.736087, 0.129527, 46.38575575795794, 0.983196, 0.743758, 0.138453, 46.59953861311636, 0.982228, 0.751442, 0.147565, 46.81332146827478, 0.981173, 0.759135, 0.156863, 47.027049814801074, 0.980032, 0.766837, 0.166353, 47.240832669959495, 0.978806, 0.774545, 0.176037, 47.4545610164858, 0.977497, 0.782258, 0.185923, 47.66834387164422, 0.976108, 0.789974, 0.196018, 47.88207221817052, 0.974638, 0.797692, 0.206332, 48.09585507332894, 0.973088, 0.805409, 0.216877, 48.30963792848736, 0.971468, 0.813122, 0.227658, 48.52336627501366, 0.969783, 0.820825, 0.238686, 48.73714913017208, 0.968041, 0.828515, 0.249972, 48.95087747669838, 0.966243, 0.836191, 0.261534, 49.1646603318568, 0.964394, 0.843848, 0.273391, 49.378388678383104, 0.962517, 0.851476, 0.285546, 49.59217153354152, 0.960626, 0.859069, 0.29801, 49.80589988006783, 0.95872, 0.866624, 0.31082, 50.01968273522624, 0.956834, 0.874129, 0.323974, 50.23346559038466, 0.954997, 0.881569, 0.337475, 50.44719393691096, 0.953215, 0.888942, 0.351369, 50.660976792069384, 0.951546, 0.896226, 0.365627, 50.87470513859568, 0.950018, 0.903409, 0.380271, 51.0884879937541, 0.948683, 0.910473, 0.395289, 51.30221634028041, 0.947594, 0.917399, 0.410665, 51.51599919543882, 0.946809, 0.924168, 0.426373, 51.729782050597244, 0.946392, 0.930761, 0.442367, 51.943510397123546, 0.946403, 0.937159, 0.458592, 52.15729325228197, 0.946903, 0.943348, 0.47497, 52.37102159880826, 0.947937, 0.949318, 0.491426, 52.58480445396668, 0.949545, 0.955063, 0.50786, 52.798532800492985, 0.95174, 0.960587, 0.524203, 53.012315655651406, 0.954529, 0.965896, 0.540361, 53.22609851080983, 0.957896, 0.971003, 0.556275, 53.43982685733613, 0.961812, 0.975924, 0.571925, 53.65360971249455, 0.966249, 0.980678, 0.587206, 53.867338059020845, 0.971162, 0.985282, 0.602154, 54.081120914179266, 0.976511, 0.989753, 0.61676, 54.29484926070557, 0.982257, 0.994109, 0.631017, 54.50863211586399, 0.988362, 0.998364, 0.644924]
uLUT.NanColor = [0.0, 1.0, 0.0]
uLUT.ScalarRangeInitialized = 1.0

# trace defaults for the display properties.
glyph2Display.Representation = 'Surface'
glyph2Display.ColorArrayName = ['POINTS', 'U']
glyph2Display.LookupTable = uLUT
glyph2Display.SelectTCoordArray = 'None'
glyph2Display.SelectNormalArray = 'None'
glyph2Display.SelectTangentArray = 'None'
glyph2Display.OSPRayScaleArray = 'T'
glyph2Display.OSPRayScaleFunction = 'Piecewise Function'
glyph2Display.Assembly = 'Hierarchy'
glyph2Display.SelectOrientationVectors = 'None'
glyph2Display.ScaleFactor = 23.262185668945314
glyph2Display.SelectScaleArray = 'None'
glyph2Display.GlyphType = 'Arrow'
glyph2Display.GlyphTableIndexArray = 'None'
glyph2Display.GaussianRadius = 1.1631092834472656
glyph2Display.SetScaleArray = ['POINTS', 'T']
glyph2Display.ScaleTransferFunction = 'Piecewise Function'
glyph2Display.OpacityArray = ['POINTS', 'T']
glyph2Display.OpacityTransferFunction = 'Piecewise Function'
glyph2Display.DataAxesGrid = 'Grid Axes Representation'
glyph2Display.PolarAxes = 'Polar Axes Representation'
glyph2Display.SelectInputVectors = ['POINTS', 'U']
glyph2Display.WriteLog = ''

# init the 'Piecewise Function' selected for 'ScaleTransferFunction'
glyph2Display.ScaleTransferFunction.Points = [300.0, 0.0, 0.5, 0.0, 400.0, 1.0, 0.5, 0.0]

# init the 'Piecewise Function' selected for 'OpacityTransferFunction'
glyph2Display.OpacityTransferFunction.Points = [300.0, 0.0, 0.5, 0.0, 400.0, 1.0, 0.5, 0.0]

# show data from plotOverLine1
plotOverLine1Display_2 = Show(plotOverLine1, renderView1, 'GeometryRepresentation')

# trace defaults for the display properties.
plotOverLine1Display_2.Representation = 'Surface'
plotOverLine1Display_2.ColorArrayName = ['POINTS', 'T']
plotOverLine1Display_2.LookupTable = tLUT
plotOverLine1Display_2.SelectTCoordArray = 'None'
plotOverLine1Display_2.SelectNormalArray = 'None'
plotOverLine1Display_2.SelectTangentArray = 'None'
plotOverLine1Display_2.OSPRayScaleArray = 'T'
plotOverLine1Display_2.OSPRayScaleFunction = 'Piecewise Function'
plotOverLine1Display_2.Assembly = ''
plotOverLine1Display_2.SelectOrientationVectors = 'None'
plotOverLine1Display_2.ScaleFactor = 4.6000000000000005
plotOverLine1Display_2.SelectScaleArray = 'None'
plotOverLine1Display_2.GlyphType = 'Arrow'
plotOverLine1Display_2.GlyphTableIndexArray = 'None'
plotOverLine1Display_2.GaussianRadius = 0.23
plotOverLine1Display_2.SetScaleArray = ['POINTS', 'T']
plotOverLine1Display_2.ScaleTransferFunction = 'Piecewise Function'
plotOverLine1Display_2.OpacityArray = ['POINTS', 'T']
plotOverLine1Display_2.OpacityTransferFunction = 'Piecewise Function'
plotOverLine1Display_2.DataAxesGrid = 'Grid Axes Representation'
plotOverLine1Display_2.PolarAxes = 'Polar Axes Representation'
plotOverLine1Display_2.SelectInputVectors = ['POINTS', 'U']
plotOverLine1Display_2.WriteLog = ''

# init the 'Piecewise Function' selected for 'ScaleTransferFunction'
plotOverLine1Display_2.ScaleTransferFunction.Points = [300.0, 0.0, 0.5, 0.0, 300.0625, 1.0, 0.5, 0.0]

# init the 'Piecewise Function' selected for 'OpacityTransferFunction'
plotOverLine1Display_2.OpacityTransferFunction.Points = [300.0, 0.0, 0.5, 0.0, 300.0625, 1.0, 0.5, 0.0]

# setup the color legend parameters for each legend in this view

# get color legend/bar for tLUT in view renderView1
tLUTColorBar = GetScalarBar(tLUT, renderView1)
tLUTColorBar.Orientation = 'Horizontal'
tLUTColorBar.WindowLocation = 'Any Location'
tLUTColorBar.Position = [0.37422297297297297, 0.7559378552481999]
tLUTColorBar.Title = 'T'
tLUTColorBar.ComponentTitle = ''
tLUTColorBar.ScalarBarLength = 0.3299999999999997

# set color bar visibility
tLUTColorBar.Visibility = 1

# get color legend/bar for uLUT in view renderView1
uLUTColorBar = GetScalarBar(uLUT, renderView1)
uLUTColorBar.Orientation = 'Horizontal'
uLUTColorBar.WindowLocation = 'Any Location'
uLUTColorBar.Position = [0.38503378378378383, 0.05934065934065935]
uLUTColorBar.Title = 'U'
uLUTColorBar.ComponentTitle = 'Magnitude'
uLUTColorBar.ScalarBarLength = 0.3300000000000003

# set color bar visibility
uLUTColorBar.Visibility = 1

# show color legend
openfoamvtmseriesDisplay.SetScalarBarVisibility(renderView1, True)

# show color legend
glyph2Display.SetScalarBarVisibility(renderView1, True)

# show color legend
plotOverLine1Display_2.SetScalarBarVisibility(renderView1, True)

# ----------------------------------------------------------------
# setup color maps and opacity maps used in the visualization
# note: the Get..() functions create a new object, if needed
# ----------------------------------------------------------------

# get opacity transfer function/opacity map for 'U'
uPWF = GetOpacityTransferFunction('U')
uPWF.Points = [0.0, 0.0, 0.5, 0.0, 54.50863211586399, 1.0, 0.5, 0.0]
uPWF.ScalarRangeInitialized = 1

# get opacity transfer function/opacity map for 'T'
tPWF = GetOpacityTransferFunction('T')
tPWF.Points = [250.0, 1.0, 0.5, 0.0, 400.0, 1.0, 0.5, 0.0]
tPWF.ScalarRangeInitialized = 1

# ----------------------------------------------------------------
# setup animation scene, tracks and keyframes
# note: the Get..() functions create a new object, if needed
# ----------------------------------------------------------------

# get the time-keeper
timeKeeper1 = GetTimeKeeper()

# initialize the timekeeper

# get time animation track
timeAnimationCue1 = GetTimeTrack()

# initialize the animation track

# get animation scene
animationScene1 = GetAnimationScene()

# initialize the animation scene
animationScene1.ViewModules = [renderView1, lineChartView1, lineChartView2]
animationScene1.Cues = timeAnimationCue1
animationScene1.AnimationTime = 100.0
animationScene1.EndTime = 1000.0
animationScene1.PlayMode = 'Snap To TimeSteps'

# initialize the animation scene

# ----------------------------------------------------------------
# restore active source
SetActiveSource(openfoamvtmseries)
# ----------------------------------------------------------------


##--------------------------------------------
## You may need to add some code at the end of this python script depending on your usage, eg:
#
## Render all views to see them appears
# RenderAllViews()
#
## Interact with the view, usefull when running from pvpython
# Interact()
#
## Save a screenshot of the active view
# SaveScreenshot("path/to/screenshot.png")
#
## Save a screenshot of a layout (multiple splitted view)
# SaveScreenshot("path/to/screenshot.png", GetLayout())
#
## Save all "Extractors" from the pipeline browser
# SaveExtracts()
#
## Save a animation of the current active view
# SaveAnimation()
#
## Please refer to the documentation of paraview.simple
## https://kitware.github.io/paraview-docs/latest/python/paraview.simple.html
##--------------------------------------------
% Auto-generated by cameraCalibrator app on 01-Oct-2023
%-------------------------------------------------------


% Define images to process
imageFileNames = {'/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image1.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image2.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image3.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image4.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image5.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image6.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image7.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image8.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image9.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image13.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image17.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image18.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image19.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image25.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image26.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image27.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image28.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image34.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image35.png',...
    '/home/smrosario/rbe3001/RBE3001_A23_Team4/src/camera_calibration/Image40.png',...
    };
% Detect calibration pattern in images
detector = vision.calibration.monocular.CheckerboardDetector();
[imagePoints, imagesUsed] = detectPatternPoints(detector, imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates for the planar pattern keypoints
squareSize = 25;  % in units of 'millimeters'
worldPoints = generateWorldPoints(detector, 'SquareSize', squareSize);

% Calibrate the camera using fisheye parameters
[cameraParams, imagesUsed, estimationErrors] = estimateFisheyeParameters(imagePoints, worldPoints, ...
    [mrows, ncols], ...
    'EstimateAlignment', false, ...
    'WorldUnits', 'millimeters');

% View reprojection errors
h1=figure; showReprojectionErrors(cameraParams);

% Visualize pattern locations
h2=figure; showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, cameraParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortFisheyeImage(originalImage, cameraParams.Intrinsics);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')

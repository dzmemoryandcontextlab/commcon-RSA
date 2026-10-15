# this script creates a mosaic for the ROI figure using MRIcroGL

import os
import gl

gl.resetdefaults()
gl.backcolor(255, 255, 255)
gl.colorbarposition(0)

gl.loadimage('spm152')   

# --- Define each ROI with its own directory ---
rois = [
    # (full path to file,                                 R,   G,   B)
    (r"/Volumes/Poodle/Baldassano_ROIs/resampled/PMC_3mm.nii_resampled.nii.gz", 227,26,28), # red 
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/left_A1_mask_resampled.nii",                  255,127,0),  # orange
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/right_A1_mask_resampled.nii", 255,127,0),  # orange
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/left_parahippocampus_mask_resampled.nii", 106,61,154),  # purple
     (r"/Volumes/Chi/HCPex_v1.1/ROIs/right_parahippocampus_mask_resampled.nii", 106,61,154),  # purple
	(r"/Volumes/Chi/HCPex_v1.1/ROIs/left_perirhinal_mask_resampled.nii", 255,255,153),  # yellow
	(r"/Volumes/Chi/HCPex_v1.1/ROIs/right_perirhinal_mask_resampled.nii", 255,255,153),  # yellow
(r"/Volumes/Poodle/VmPFC_symmetric_20141024/resampled/vmPFC_left_resampled.nii.gz", 177,89,40),  # brown
(r"/Volumes/Poodle/VmPFC_symmetric_20141024/resampled/vmPFC_right_resampled.nii.gz", 177,89,40),  # brown
(r"/Volumes/Poodle/ashs-ROIs/sub-01_left_Hippocampus_MNI-BOLD.nii", 31,120,180),  # blue
(r"/Volumes/Poodle/ashs-ROIs/sub-01_right_Hippocampus_MNI-BOLD.nii", 31,120,180),  # blue
]

for i, (path, r, g, b) in enumerate(rois, start=1):
    if not os.path.isfile(path):
        print("WARNING: file not found:", path)
        continue
    gl.overlayload(path)
    gl.colorname(i, 'Grayscale')
    gl.colornode(i, 0, 0,   r, g, b, 255)
    gl.colornode(i, 1, 128, r, g, b, 255)
    gl.colornode(i, 2, 255, r, g, b, 255)


gl.mosaic("C -72 C -60 C -48 C -36; C -22 C -10 C 2 C 16; C 28 C 40 C 52 S X R 0;")
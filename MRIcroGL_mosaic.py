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
    (r"/Volumes/Poodle/Baldassano_ROIs/resampled/PMC_3mm_resampled_bin.nii", 58, 169, 159), # cyan
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/left_A1_mask_resampled.nii",                  209, 77, 65),  # red
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/right_A1_mask_resampled.nii", 209, 77, 65),  # red
    (r"/Volumes/Poodle/ashs-ROIs/sub-01_left_PHC_MNI-BOLD.nii", 218, 112, 44),  # orange
     (r"/Volumes/Poodle/ashs-ROIs/sub-01_right_PHC_MNI-BOLD.nii", 218, 112, 44),  # orange
	(r"/Volumes/Poodle/ashs-ROIs/sub-01_left_PRC_MNI-BOLD.nii", 208, 162, 21), # yellow
	(r"/Volumes/Poodle/ashs-ROIs/sub-01_right_PRC_MNI-BOLD.nii", 208, 162, 21),  # yellow
(r"/Volumes/Poodle/VmPFC_symmetric_20141024/resampled/vmPFC_left_resampled.nii.gz", 139, 126, 200), # purple  
(r"/Volumes/Poodle/VmPFC_symmetric_20141024/resampled/vmPFC_right_resampled.nii.gz", 139, 126, 200), # purple
(r"/Volumes/Poodle/ashs-ROIs/sub-01_left_Hippocampus_MNI-BOLD.nii", 206, 93, 151),  # magenta
(r"/Volumes/Poodle/ashs-ROIs/sub-01_right_Hippocampus_MNI-BOLD.nii", 206, 93, 151),  # magenta
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

# adjust glass brain
gl.shadername('Glass')
gl.shaderadjust('Brightness', 0.6)
gl.linewidth(0)


gl.mosaic("L+ C -72 C -60 C -48 C -36; C -22 C -10 C 2 C 16; C 28 C 40 C 52 S X R 0;")
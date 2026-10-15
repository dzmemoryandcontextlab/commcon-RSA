# this script creates a mosaic for the ROI figure using MRIcroGL

import os
import gl

gl.resetdefaults()
gl.backcolor(0, 0, 0)
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

# adjust glass brain render
gl.shadername('Glass')
gl.shaderadjust('Brightness', 0.6)
gl.linewidth(0)

gl.mosaic(
    # "L+ " # uncomment for slice number labels \ 
    "C -60 -36 -22 28;" \
    "S 5 30 40 S; " \
    # "C X R 0 S X R 0 A X R 0;" # uncomment for glass brains
    )


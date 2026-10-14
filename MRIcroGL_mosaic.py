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
    (r"/Volumes/Poodle/Baldassano_ROIs/resampled/PMC_3mm.nii_resampled.nii.gz", 128, 0, 128), # purple 
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/left_A1_mask_resampled.nii",                  46, 184,  46),  # green
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/right_A1_mask_resampled.nii", 72, 164, 255),  # blue
    (r"/Volumes/Chi/HCPex_v1.1/ROIs/left_parahippocampus_mask_resampled.nii", 230, 138,   0),  # orange
     (r"/Volumes/Chi/HCPex_v1.1/ROIs/right_parahippocampus_mask_resampled.nii", 230, 138,   0),  # orange
	(r"/Volumes/Chi/HCPex_v1.1/ROIs/left_perirhinal_mask_resampled.nii", 230, 138,   0),  # orange
	(r"/Volumes/Chi/HCPex_v1.1/ROIs/right_perirhinal_mask_resampled.nii", 230, 138,   0),  # orange
(r"/Volumes/Poodle/VmPFC_symmetric_20141024/resampled/vmPFC_left_resampled.nii.gz", 230, 138,   0),  # orange
(r"/Volumes/Poodle/VmPFC_symmetric_20141024/resampled/vmPFC_right_resampled.nii.gz", 230, 138,   0),  # orange
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

gl.mosaic("C -60 C -36 C -22 C 16 C 52;")
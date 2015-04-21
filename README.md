# Photometric Stereo

This project is a Matlab implementation of photometric stereo, a technique to estimate the surface normals and the depth map of an object based on the pixel brightness of the object’s image when subjected to a light source placed at different light source (Woodham 1980).

For example, our input is photos of an object taken from the same camera's position but illuminated by a lamp placed at different positions.
![photometric stereo input images](http://res.cloudinary.com/mockup-giveasia/image/upload/v1480410057/photometric-stereo-input_xpqexv.jpg)

The output is the the map of normals of the object’s surface, and the depth map of the object’s surface.
![photometric stereo output](http://res.cloudinary.com/mockup-giveasia/image/upload/v1480410412/photometric-stereo-output_wnm0df.jpg)
(the intensity of each RGB color channel at a given point in image a) corresponds to the magnitude in X, Y, Z direction of the normal at the same point on the object's surfcace)

# Dense Photometric Stereo

Dense photometric stereo is an approach for robust normal reconstruction from noisy images using Markov Random Field (MRF) (Wu et al. 2006). This project contains the implementation of Tensor Belief Propagation (TBP) to optimize the MRF, using a denominator image for initialization.

The figure shows the initial image and the optimized image after 20 iterations.
![TBP result](http://res.cloudinary.com/mockup-giveasia/image/upload/v1480415237/tbp_output_hg3nhp.jpg)

# Data
`liZhangData` is from [Dr Li Zhang's course](http://courses.cs.washington.edu/courses/cse455/10wi/projects/project4/).
`darumaData` is my self-created data:
![daruma setup](http://res.cloudinary.com/mockup-giveasia/image/upload/v1480412051/daruma_setup_k0mfj9.jpg)

# Instruction
- Run Photometric Stereo by the command
`PhotometricStereo(root_dir, image_name, number_of_images)`
e.g: `PhotometricStereo('darumaData', 'daruma', 14)`

- Run Photometric Stereo with Tensor Based Propagation by the command
`StereoTBP(root_dir, image_name, number_of_images)`
e.g: `StereoTBP('darumaData', 'daruma', 14)`


# References
[1] Woodham RJ, “Photometric method for determining surface orientation from multiple images,” Optical engineering, vol. 19, no. 1, pp. 191 139–191 139, 1980.
[2] Wu TP, Tang KL, Tang CK, and Wong TT, “Dense photometric stereo: A markov random field approach,” Pattern Analysis and Machine Intelligence, IEEE Transactions on, vol. 28, no. 11, pp. 1830–1846, 2006.

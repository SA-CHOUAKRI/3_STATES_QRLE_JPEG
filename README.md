CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m is application of CHOUAKRI_3_STATES_QRLE function to a classical JPEG RGB image compression algorithm.  In this code, DCT-AC coefficients Huffman coding is replaced by CHOUAKRI_3_STATES_QRLE function.   
CHOUAKRI_3_STATES_QRLE function is based on a so-called QRLE (Quantized Run Length Encoding) -see https://ieeexplore.ieee.org/abstract/document/8855775- 
The basic idea is to treat the zero run numbers of the AC zig-zag coefficients, according  to 3 pre-defined ranges as follows where it comes the expression 3 States QRLE: [1..127], [128..255], and [256..maximum. 
For more information see: -https://www.researchgate.net/publication/366802356_Three_States_QRLE_Quantized_Run_Length_Encoding_Based_JPEG_Image_Compression_Method -
 
CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m improves considerably the Compression Ratio CR compared to the classical JPEG RGB image compression algorithm ‘Classical_JPEG_main.m’.
The compared obtained results, employing CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m VS. CLASSICAL JPEG algorithms in terms of CR are, respectively, 39.6654, 74.0682, and 53.4297 VS. 18.9290, 20.7876, and 17.8256 by testing 'peppers.png', 'ngc6543a.jpg', and 'house.tiff' RGB images
However, the PSNR values are kept the same for both algorithms since CHOUAKRI_3_STATES_QRLE function and Huffman coding are lossless compression methods.

Running program, the name of RGB image, as string, e.g. 'ngc6543a.jpg' and the Quantification Quality, as scalar usually equals to 3 have to entered. The CR and PSNR values are provided at the end of execution as well as the figures of the original, reconstructed, and the difference versions of the tested RGB image.

Similarly to the classical JPEG code, CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m appeals a set of third-party functions (in zip-format file) such as 'DCdif_fn.m', 'DC_Huff_fn.m'... Inversely to the classical JPEG code, CHOUAKRI_3_STATES_QRLE_JPEG_MAIN.m appeals CHOUAKRI_3_STATES_QRLE function instead of 'AC_De_Huff.m', 'AC_Huff.m',and 'AC_Huff_fn.m'.

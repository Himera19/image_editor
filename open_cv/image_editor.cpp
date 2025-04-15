#include <opencv2/opencv.hpp>
using namespace cv;

/**
 * Image filtering functions using OpenCV.
 * This file contains functions for applying image filters.
 */
extern "C" {


    /**
     * Apply grayscale filter to input image.
     * @param inputPath - Path to input image file.
     * @param outputPath - Path where the processed image will be saved.
     */
    void apply_grayscale(const char* inputPath, const char* outputPath) {
        // Load the input image.
        Mat image = imread(inputPath);
        if (image.empty()) return;

        // Apply grayscale filter.
        Mat gray;
        cvtColor(image, gray, COLOR_BGR2GRAY);
        // Save the result
        bool success = imwrite(outputPath, gray);
        if (!success) {
           printf("Failed to save the processed image: %s\n", outputPath);
        }}

    /**
    * Apply blur filter to input image.
    * @param inputPath - Path to input image file.
    * @param outputPath - Path where the processed image will be saved.
    */
    void  apply_blur (const char* inputPath, const char* outputPath){
        // Load the input image.
        Mat image = imread(inputPath);
        if(image.empty()) return;

        // Apply Gaussian blur filter.
        Mat blurred;
        blur(image, blurred, Size(11,11));
        // Save the result.
        bool success = imwrite(outputPath, blurred);
        if (!success) {
            printf("Failed to save the processed image: %s\n", outputPath);
        }}

    /**
     * Apply sharpen filter to input image.
     * @param inputPath - Path to input image file.
     * @param outputPath - Path where the processed image will be saved.
     */
    void apply_sharpen(const char* inputPath, const char* outputPath){

        // Load the input image.
        Mat image = imread(inputPath);
        if (image.empty()) return;

        // Define sharpening kernel (3x3).
        Mat kernel = (Mat_<float>(3,3)<< 0,-1,0,-1,10,-1,0,-1,0);
        // Define output image.
        Mat sharpened;

        // Apply sharpened kernel to image.
        filter2D(image, sharpened,image.depth(),kernel);

        // Save the result.
        bool success = imwrite(outputPath, sharpened);
        if (!success) {
            printf("Failed to save the processed image: %s\n", outputPath);
        }}

    /**
     * Apply edge filter to input image.
     * @param inputPath - Path to input image file.
     * @param outputPath - Path where the processed image will be saved.
     */
    void apply_edge(const char* inputPath, const char* outputPath){
        // Load the input image.
        Mat image = imread(inputPath);
        if (image.empty()) return;

        // Define outputs.
        Mat gray, edges;

        // Apply grayscale to image for canny edge detection.
        cvtColor(image,gray, COLOR_BGR2GRAY);

        // Apply canny edge detection to grayscale image.
        Canny(gray,edges,100,200);

        // Save the result.
        bool success = imwrite(outputPath, edges);
        if (!success) {
            printf("Failed to save the processed image: %s\n", outputPath);
        }}
    }
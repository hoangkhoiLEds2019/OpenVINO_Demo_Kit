#!/bin/bash
# File: OpenVINO_demo_SYNNEX.sh
# 2019/04/16	henry1758f 2.0.0	First Create
# 2019/04/30	henry1758f 2.0.1	create excute path of Human Pose Estimation and security barrier camera


export VERSION="2.0.1"
export VERSION_VINO="v2019.1.094"
export INTEL_OPENVINO_DIR=/opt/intel/openvino/
export SAMPLE_LOC="/home/$(whoami)/inference_engine_samples_build/intel64/Release"
export Source_Sample_Build="./Source/sample_build.sh"
export Source_Model_Downloader="./Source/model_downloader.sh"
export SOURCE=./Source/

function Inference_Engine_Sample_List()
{
	echo "|=========================================|"
	echo "|        Intel OpenVINO Demostration      |"
	echo "|        Inference Engine Sample Demo     |"
	echo "|                                         |"
	echo "|=========================================|"
	echo ""
	echo "  1. security_barrier_camera_demo (TBD)"
	echo "  2. interactive_face_detection_demo (TBD)"
	echo "  3. classification_demo (TBD)"
	echo "  4. Human Pose Estimation Demo."
	echo "  5. Object Detection SSD Demo - Async API.(TBD)"
	echo "  6. Crossroad Camera Demo (TBD)"
	echo "  7. super_resolution_demo (TBD)"
	echo "  8. pedestrian tracker demo (TBD)"
	echo "  9. smart_classroom_dem (TBD)"
	echo " 10. Neural Style Transfer Sample (TBD)"
	echo " 11. Image Segmentation Demo (TBD)"

	local choose
	read choose
	case $choose in
		"1")
			echo " You choose security_barrier_camera_demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}security_barrier_camera_demo.sh
			;;
		"4")
			echo " Human Pose Estimation Demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}human_pose_estimation_demo.sh
			;;
		*)
			echo "Please input a vailed number"
			sleep 1
			clear
			banner_show
			Inference_Engine_Sample_List
			;;
	esac









}

function feature_choose()
{
	echo " 1. Inference Engine Sample Demo."
	echo " 2. Model Optimizer Demo. (TBD)"
	test -e ${SAMPLE_LOC}/benchmark_app && echo " 3. Sample Build.(Done!)" || echo " 3. Sample Build."
	echo " 4. Model Downloader."


	local choose
	read choose
	case $choose in
		"1")
			Inference_Engine_Sample_List
		;;
		"2")
			#echo "Sorry, The Model Optimizer Demo isn't ready..."
			Model_Optimizer_Sample_List
			;;
		"3")
			$Source_Sample_Build
			clear
			banner_show
			feature_choose
		;;
		"4")
			$Source_Model_Downloader
			clear
			banner_show
			feature_choose
		;;
		*)
			echo "Please input a vailed number"
			sleep 1
			clear
			banner_show
			feature_choose
			;;
	esac

}

function banner_show()
{
	echo
	echo "|=========================================|"
	echo "|  SYNNEX TECHNOLOGY INTERNATIONAL CORP.  |"
	echo "|                                         |"
	echo "|        Intel OpenVINO Demostration      |"
	echo "|=========================================|"
	echo "  Ver. $VERSION | Support OpenVINO $VERSION_VINO"
	echo ""
}


banner_show
feature_choose


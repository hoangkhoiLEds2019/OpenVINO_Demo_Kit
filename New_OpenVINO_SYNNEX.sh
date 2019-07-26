#!/bin/bash
# File: OpenVINO_demo_SYNNEX.sh
# 2019/04/16	henry1758f 2.0.0	First Create
# 2019/07/25	henry1758f 2.10.0	Add super_resolution_demo
# 2019/07/25	henry1758f 3.0.0-beta.0	fit OpenVINO 2019R2 - sample build and model downloader
# 2019/07/25	henry1758f 3.0.0-beta.1	fit OpenVINO 2019R2 - security_barrier_camera_demo
# 2019/07/25	henry1758f 3.0.0-beta.2	fit OpenVINO 2019R2 - interactive_face_detection_demo
# 2019/07/26	henry1758f 3.0.0-beta.3	fit OpenVINO 2019R2 - classification_demo
# 2019/07/26	henry1758f 3.0.0-beta.4	fit OpenVINO 2019R2 - human_pose_estimation_demo
# 2019/07/26	henry1758f 3.0.0-beta.5	fit OpenVINO 2019R2 - object_detection_demo_ssd_async
# 2019/07/26	henry1758f 3.0.0-beta.6	fit OpenVINO 2019R2 - crossroad_camera_demo
# 2019/07/26	henry1758f 3.0.0-beta.7	fit OpenVINO 2019R2 - super_resolution_demo
# 2019/07/26	henry1758f 3.0.0-beta.8	fit OpenVINO 2019R2 - smart_classroom_demo

export VERSION="3.0.0-beta.8"
export VERSION_VINO="v2019.2.242"
export INTEL_OPENVINO_DIR=/opt/intel/openvino/
export SAMPLE_LOC="$HOME/inference_engine_samples_build/intel64/Release"
export DEMO_LOC="$HOME/inference_engine_demos_build/intel64/Release"
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
	echo "  1. security_barrier_camera_demo."
	echo "  2. interactive_face_detection_demo."
	echo "  3. classification_demo."
	echo "  4. Human Pose Estimation Demo."
	echo "  5. Object Detection and ASYNC API Demo."
	echo "  6. Crossroad Camera Demo."
	echo "  7. super_resolution_demo."
	echo "  8. pedestrian tracker demo (TBD)"
	echo "  9. smart_classroom_demo."
	echo " 10. Neural Style Transfer Sample (TBD)"
	echo " 11. Image Segmentation Demo (TBD)"
	echo " 12. Speech Sample (TBD)"

	local choose
	read choose
	case $choose in
		"1")
			echo " You choose security_barrier_camera_demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}security_barrier_camera_demo.sh
			;;
		"2")
			echo " You choose interactive_face_detection_demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}interactive_face_detection_demo.sh
		;;
		"3")
			echo " You choose classification_demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}classification_demo.sh
		;;
		"4")
			echo " Human Pose Estimation Demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}human_pose_estimation_demo.sh
			;;
		"5")
			echo " Object Detection and ASYNC API Demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}object_detection_demo_ssd_async.sh
			;;
		"6")
			echo " Crossroad Camera Demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}crossroad_camera_demo.sh
		;;
		"7")
			echo " super_resolution_demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}super_resolution_demo.sh
		;;
		"9")
			echo " smart_classroom_demo ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}smart_classroom_demo.sh
		;;
		"12")
			echo " Speech Sample (TBD) ->"
			source ${INTEL_OPENVINO_DIR}/bin/setupvars.sh
			${SOURCE}speech_sample.sh
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
	test -e ${SAMPLE_LOC}/benchmark_app && echo " 2. Sample Build.(Done!)" || echo " 2. Sample Build."
	echo " 3. Model Downloader."


	local choose
	read choose
	case $choose in
		"1")
			Inference_Engine_Sample_List
		;;
		"2")
			$Source_Sample_Build
			clear
			banner_show
			feature_choose
		;;
		"3")
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



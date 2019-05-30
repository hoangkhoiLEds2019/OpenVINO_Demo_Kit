# File: object_detection_demo_ssd_async.sh
# 2019/05/09	henry1758f 0.0.1	First Create
# 2019/05/09	henry1758f 1.0.0	Workable
# 2019/05/30	henry1758f 1.1.0	Add ssd_mobilenet_v1,ssd512 and ssd300. Support labels.
# 2019/05/30	henry1758f 1.1.1	Add mobilenet-ssd but without labels.
export INTEL_OPENVINO_DIR=/opt/intel/openvino/
export SAMPLE_LOC="/home/$(whoami)/inference_engine_samples_build/intel64/Release"
export MODEL_LOC=/home/$(whoami)/openvino_models/models/SYNNEX_demo

export ssd_mobilenet_v2_coco_frozen="${MODEL_LOC}/../../ir/FP32/object_detection/common/ssd_mobilenet_v2_coco/tf"
export ssd_mobilenet_v2_coco_frozen_fp16="${MODEL_LOC}/../../ir/FP16/object_detection/common/ssd_mobilenet_v2_coco/tf"
export ssd_mobilenet_v1_coco_frozen="${MODEL_LOC}/../../ir/FP32/object_detection/common/ssd_mobilenet/ssd_mobilenet_v1_coco/tf/ssd_mobilenet_v1_coco_2018_01_28"
export ssd_mobilenet_v1_coco_frozen_fp16="${MODEL_LOC}/../../ir/FP16/object_detection/common/ssd_mobilenet/ssd_mobilenet_v1_coco/tf/ssd_mobilenet_v1_coco_2018_01_28"
export ssd_512="${MODEL_LOC}/../../ir/FP32/object_detection/common/ssd/512/caffe"
export ssd_512_fp16="${MODEL_LOC}/../../ir/FP16/object_detection/common/ssd/512/caffe"
export ssd_300="${MODEL_LOC}/../../ir/FP32/object_detection/common/ssd/300/caffe"
export ssd_300_fp16="${MODEL_LOC}/../../ir/FP16/object_detection/common/ssd/300/caffe"
export mobilenet_ssd="${MODEL_LOC}/../../ir/FP32/object_detection/common/mobilenet-ssd/caffe"
export mobilenet_ssd_fp16="${MODEL_LOC}/../../ir/FP16/object_detection/common/mobilenet-ssd/caffe"


function banner_show()
{
	echo "|=========================================|"
	echo "|   Object Detection and ASYNC API Demo   |"
	echo "|=========================================|"
}

function inference_D_choose()
{
	echo " >> CPU(FP32),GPU(FP32/16),MYRIAD(FP16),HDDL(FP16),HETERO...Please choose your target device."
	read TARGET_0
}
function model_0_choose()
{
	echo " [Select a Object Detection model.]"
	test -e ${ssd_mobilenet_v2_coco_frozen}/ssd_mobilenet_v2_coco.frozen.xml && echo " 1. ssd_mobilenet_v2_coco.frozen.xml [FP32]" || echo " 1. ssd_mobilenet_v2_coco.frozen.xml [FP32]	File lost! Need to Download and Transfer to IR)"
	test -e ${ssd_mobilenet_v2_coco_frozen_fp16}/ssd_mobilenet_v2_coco.frozen.xml && echo " 2. ssd_mobilenet_v2_coco.frozen.xml [FP16]" || echo " 2. ssd_mobilenet_v2_coco.frozen.xml [FP16]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP32/object_detection/common/ssd_mobilenet/ssd_mobilenet_v1_coco/tf/ssd_mobilenet_v1_coco_2018_01_28/frozen_inference_graph.xml && echo " 3. frozen_inference_graph.xml [ssd_mobilenet_v1_coco_FP32]" || echo " 3. frozen_inference_graph.xml [ssd_mobilenet_v1_coco_P32]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP16/object_detection/common/ssd_mobilenet/ssd_mobilenet_v1_coco/tf/ssd_mobilenet_v1_coco_2018_01_28/frozen_inference_graph.xml && echo " 4. frozen_inference_graph.xml [ssd_mobilenet_v1_coco_FP16]" || echo " 4. frozen_inference_graph.xml [ssd_mobilenet_v1_coco_FP16]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP32/object_detection/common/mobilenet_ssd/caffe/mobilenet-ssd.xml && echo " 5. mobilenet-ssd.xml [FP32]" || echo " 5. mobilenet-ssd.xml [FP32]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP16/object_detection/common/mobilenet_ssd/caffe/mobilenet-ssd.xml && echo " 6. mobilenet-ssd.xml [FP16]" || echo " 6. mobilenet-ssd.xml [FP16]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP32/object_detection/common/ssd/512/caffe/ssd512.xml && echo " 7. ssd512.xml [FP32]" || echo " 7. ssd512.xml [FP32]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP16/object_detection/common/ssd/512/caffe/ssd512.xml && echo " 8. ssd512.xml [FP16]" || echo " 8. ssd512.xml [FP16]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP32/object_detection/common/ssd/300/caffe/ssd300.xml && echo " 9. ssd300.xml [FP32]" || echo " 9. ssd300.xml [FP32]	File lost! Need to Download and Transfer to IR)"
	test -e ${MODEL_LOC}/../../ir/FP16/object_detection/common/ssd/300/caffe/ssd300.xml && echo "10. ssd300.xml [FP16]" || echo "10. ssd300.xml [FP16]	File lost! Need to Download and Transfer to IR)"
	echo " >>11. face-detection-adas-0001 "
	echo " >>12. face-detection-adas-0001-fp16 "
	echo " >>13. face-detection-retail-0004"
	echo " >>14. face-detection-retail-0004-fp16"
	echo " >> Or input a path to your model "
	local choose
	read choose
	case $choose in
		"1")
			echo " ssd_mobilenet_v2_coco_frozen.xml [FP32] ->"
			test -e ${ssd_mobilenet_v2_coco_frozen}/ssd_mobilenet_v2_coco.frozen.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd_mobilenet_v2_coco.frozen.pb -fp32 && cp -r ./Source/labels/ssd_mobilenet_v2_coco_2018_03_29/ssd_mobilenet_v2_coco.frozen.labels ${ssd_mobilenet_v2_coco_frozen})
			MODEL_LOC_0=${ssd_mobilenet_v2_coco_frozen}/ssd_mobilenet_v2_coco.frozen.xml
			inference_D_choose
		;;
		"2")
			echo " ssd_mobilenet_v2_coco.frozen.xml [FP16] ->"
			test -e ${ssd_mobilenet_v2_coco_frozen_fp16}/ssd_mobilenet_v2_coco.frozen.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd_mobilenet_v2_coco.frozen.pb -fp16 && cp -r ./Source/labels/ssd_mobilenet_v2_coco_2018_03_29/ssd_mobilenet_v2_coco.frozen.labels ${ssd_mobilenet_v2_coco_frozen_fp16})
			MODEL_LOC_0=${ssd_mobilenet_v2_coco_frozen_fp16}/ssd_mobilenet_v2_coco.frozen.xml
			inference_D_choose
		;;
		"3")
			echo " ssd_mobilenet_v1_coco_frozen.xml [FP32] ->"
			test -e ${ssd_mobilenet_v1_coco_frozen}/frozen_inference_graph.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd_mobilenet_v1_coco.frozen.pb -fp32 && cp -r ./Source/labels/ssd_mobilenet_v1_coco_2018_01_28/frozen_inference_graph.labels ${ssd_mobilenet_v1_coco_frozen}) 
			MODEL_LOC_0=${ssd_mobilenet_v1_coco_frozen}/frozen_inference_graph.xml
			inference_D_choose
		;;
		"4")
			echo " ssd_mobilenet_v1_coco.frozen.xml [FP16] ->"
			test -e ${ssd_mobilenet_v1_coco_frozen_fp16}/frozen_inference_graph.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd_mobilenet_v1_coco.frozen.pb -fp16 && cp -r ./Source/labels/ssd_mobilenet_v1_coco_2018_01_28/frozen_inference_graph.labels ${ssd_mobilenet_v1_coco_frozen_fp16})
			MODEL_LOC_0=${ssd_mobilenet_v1_coco_frozen_fp16}/frozen_inference_graph.xml
			inference_D_choose
		;;
		"5")
			echo " mobilenet-ssd.xml [FP32] ->"
			test -e ${mobilenet_ssd}/mobilenet-ssd.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m mobilenet-ssd.caffemodel -fp32 && cp -r ./Source/labels/mobilenet-ssd/mobilenet-ssd.labels ${ssd_512}) 
			MODEL_LOC_0=${mobilenet_ssd}/mobilenet-ssd.xml
			inference_D_choose
		;;
		"6")
			echo " mobilenet-ssd.xml [FP16] ->"
			test -e ${mobilenet_ssd_fp16}/mobilenet-ssd.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m mobilenet-ssd.caffemodel -fp16 && cp -r ./Source/labels/mobilenet-ssd/mobilenet-ssd.labels ${ssd_512_fp16})
			MODEL_LOC_0=${mobilenet_ssd_fp16}/mobilenet-ssd.xml
			inference_D_choose
		;;
		"7")
			echo " ssd512.xml [FP32] ->"
			test -e ${ssd_512}/ssd512.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd512.caffemodel -fp32 && cp -r ./Source/labels/ssd_512/ssd512.labels ${ssd_512}) 
			MODEL_LOC_0=${ssd_512}/ssd512.xml
			inference_D_choose
		;;
		"8")
			echo " ssd512.xml [FP16] ->"
			test -e ${ssd_512_fp16}/ssd512.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd512.caffemodel -fp16 && cp -r ./Source/labels/ssd_512/ssd512.labels ${ssd_512_fp16})
			MODEL_LOC_0=${ssd_512_fp16}/ssd512.xml
			inference_D_choose
		;;
		"9")
			echo " ssd300.xml [FP32] ->"
			test -e ${ssd_300}/ssd300.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd300.caffemodel -fp32 && cp -r ./Source/labels/ssd_300/ssd300.labels ${ssd_300}) 
			MODEL_LOC_0=${ssd_512}/ssd512.xml
			inference_D_choose
		;;
		"10")
			echo " ssd300.xml [FP16] ->"
			test -e ${ssd_300_fp16}/ssd300.xml || ( echo "[Run Model Optimizer Demo]" && ./Source/mo_dldt.sh -m ssd300.caffemodel -fp16 && cp -r ./Source/labels/ssd_300/ssd300.labels ${ssd_300_fp16})
			MODEL_LOC_0=${ssd_300_fp16}/ssd300.xml
			inference_D_choose
		;;
		"11")
			echo " face-detection-adas-0001 ->"
			MODEL_LOC_0=${MODEL_LOC}/Transportation/object_detection/face/pruned_mobilenet_reduced_ssd_shared_weights/dldt/face-detection-adas-0001.xml
			inference_D_choose
		;;
		"12")
			echo " face-detection-adas-0001-fp16 ->"
			MODEL_LOC_0=${MODEL_LOC}/Transportation/object_detection/face/pruned_mobilenet_reduced_ssd_shared_weights/dldt/face-detection-adas-0001-fp16.xml
			inference_D_choose
		;;
		"13")
			echo " face-detection-retail-0004 ->"
			MODEL_LOC_0=${MODEL_LOC}/Retail/object_detection/face/sqnet1.0modif-ssd/0004/dldt/face-detection-retail-0004.xml
			inference_D_choose
		;;
		"14")
			echo " face-detection-retail-0004-fp16 ->"
			MODEL_LOC_0=${MODEL_LOC}/Retail/object_detection/face/sqnet1.0modif-ssd/0004/dldt/face-detection-retail-0004-fp16.xml
			inference_D_choose
		;;
		*)
			echo " Model PATH=${choose}"
			MODEL_LOC_0=${choose}
			inference_D_choose
			;;
	esac
}

function source_choose()
{
	echo " >> input \"cam\" for using camera as inference source,\"0\" for default Source, or typein the path to the source you want."
	read I_SOURCE
	case $I_SOURCE in
		"0")
			echo "Model PATH [Default]= cam"
			I_SOURCE=cam
		;;
		*)
			echo " Model PATH=${I_SOURCE}"
			;;
	esac
}

clear
banner_show
model_0_choose
source_choose
cd $SAMPLE_LOC
echo "./object_detection_demo_ssd_async -m ${MODEL_LOC_0} -i ${I_SOURCE} -d ${TARGET_0}"
./object_detection_demo_ssd_async -m ${MODEL_LOC_0} -i ${I_SOURCE} -d ${TARGET_0}
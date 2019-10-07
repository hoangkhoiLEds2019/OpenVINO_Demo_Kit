# File: super_resolution_demo.sh
# 2019/07/25	henry1758f 0.0.1	First Create
# 2019/07/25	henry1758f 2.0.0	Fit openVINO v2019.2.242
# 2019/07/25	henry1758f 2.0.1	Add some output information
# 2019/10/07	henry1758f 2.1.0	Fit openVINO v2019.3.334

export INTEL_OPENVINO_DIR=/opt/intel/openvino/
export SAMPLE_LOC="$HOME/inference_engine_samples_build/intel64/Release"
export DEMO_LOC="$HOME/inference_engine_demos_build/intel64/Release"
export MODEL_LOC=$HOME/openvino_models/models/SYNNEX_demo
export USER_IMG_LOC=$HOME/Pictures/Test_Image

function banner_show()
{
	echo "|=========================================|"
	echo "|          Super Resolution Demo          |"
	echo "|=========================================|"
}

function model_0_choose()
{
	echo " >> 1. single-image-super-resolution-1032.xml 	[FP32] 		(480x270 -> 1920x1080) "
	echo " >> 2. single-image-super-resolution-1032.xml 	[FP16] 	(480x270 -> 1920x1080) "
	echo " >> 3. single-image-super-resolution-1032.xml 	[INT8] 	(480x270 -> 1920x1080) "
	echo " >> 4. single-image-super-resolution-1033.xml 	[FP32]		(640x360 -> 1920x1080)"
	echo " >> 5. single-image-super-resolution-1033.xml 	[FP16] 	(640x360 -> 1920x1080)"
	echo " >> 6. single-image-super-resolution-1033.xml 	[INT8] 	(640x360 -> 1920x1080)"
	echo " >> Or input a path to your model "
	read choose
	case $choose in
		"1")
			echo " single-image-super-resolution-1032.xml 	[FP32] (480x270 -> 1920x1080) ->"
			MODEL_LOC=${MODEL_LOC}/intel/single-image-super-resolution-1032/FP32/single-image-super-resolution-1032.xml
			I_SOURCE=$USER_IMG_LOC/SanChungBus_Route306_620FG_wide.jpg
		;;
		"2")
			echo " single-image-super-resolution-1032.xml 	[FP16] (480x270 -> 1920x1080) ->"
			MODEL_LOC=${MODEL_LOC}/intel/single-image-super-resolution-1032/FP16/single-image-super-resolution-1032.xml
			I_SOURCE=$USER_IMG_LOC/SanChungBus_Route306_620FG_wide.jpg
		;;
		"3")
			echo " single-image-super-resolution-1032.xml 	[INT8] (480x270 -> 1920x1080) ->"
			MODEL_LOC=${MODEL_LOC}/intel/single-image-super-resolution-1032/INT8/single-image-super-resolution-1032.xml
			I_SOURCE=$USER_IMG_LOC/SanChungBus_Route306_620FG_wide.jpg
		;;
		"4")
			echo " single-image-super-resolution-1033 	[FP32] (640x360 -> 1920x1080) ->"
			MODEL_LOC=${MODEL_LOC}/intel/single-image-super-resolution-1033/FP32/single-image-super-resolution-1033.xml
			I_SOURCE=$USER_IMG_LOC/640px-20180402_091550_KKA-2591.jpg
		;;
		"5")
			echo " single-image-super-resolution-1033 	[FP16] (640x360 -> 1920x1080) ->"
			MODEL_LOC=${MODEL_LOC}/intel/single-image-super-resolution-1033/FP16/single-image-super-resolution-1033.xml
			I_SOURCE=$USER_IMG_LOC/640px-20180402_091550_KKA-2591.jpg
		;;
		"6")
			echo " single-image-super-resolution-1033 	[INT8] (640x360 -> 1920x1080) ->"
			MODEL_LOC=${MODEL_LOC}/intel/single-image-super-resolution-1033/INT8/single-image-super-resolution-1033.xml
			I_SOURCE=$USER_IMG_LOC/640px-20180402_091550_KKA-2591.jpg
		;;
		"0")
			return 1
		;;
		*)
			echo " Model PATH=${choose}"
			MODEL_LOC=${choose}
			;;
	esac
}

function inference_D_choose()
{
	echo " >> CPU,GPU,MYRIAD(FP16),HDDL(FP16),HETERO...Please choose your target device."
	read TARGET_0
}
function source_choose()
{
	echo " >> input \"0\" for download and using default image as inference source, or typein the path to the source you want."
	read source_choose
	case $source_choose in
		"0")
			test -e $USER_IMG_LOC/SanChungBus_Route306_620FG_wide.jpg || wget -P $USER_IMG_LOC https://upload.wikimedia.org/wikipedia/commons/5/51/SanChungBus_Route306_620FG_wide.jpg
			test -e $USER_IMG_LOC/640px-20180402_091550_KKA-2591.jpg || wget -P $USER_IMG_LOC https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/20180402_091550_KKA-2591.jpg/640px-20180402_091550_KKA-2591.jpg
		;;
		*)
			I_SOURCE=$source_choose
			return
		;;
	esac

}
function set_default()
{
	echo " All model will run on CPU... "
	MODEL_LOC=${MODEL_LOC}/Security/super_resolution/srresnet/dldt/1032/single-image-super-resolution-1032.xml
	test -e $USER_IMG_LOC/SanChungBus_Route306_620FG_wide.jpg || wget -P $USER_IMG_LOC https://upload.wikimedia.org/wikipedia/commons/5/51/SanChungBus_Route306_620FG_wide.jpg
	I_SOURCE=$USER_IMG_LOC/SanChungBus_Route306_620FG_wide.jpg
	TARGET_0="CPU"
}
function set_others()
{
	inference_D_choose
	source_choose
}
clear
banner_show

echo "Select Super Resolution model >>>"
model_0_choose && set_others || set_default
xdg-open ${I_SOURCE}
cd $DEMO_LOC
ARGS=" -m ${MODEL_LOC} -i ${I_SOURCE} -d ${TARGET_0}"
echo "RUN ./super_resolution_demo $ARGS"
./super_resolution_demo $ARGS
cp -r sr_1.png $HOME/Pictures/
rm sr_1.png
echo " [INFO] Output Image had been saved as $HOME/Pictures/sr_1.png"
xdg-open $HOME/Pictures/sr_1.png
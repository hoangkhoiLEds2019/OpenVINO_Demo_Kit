# File: action_recognition_demo.py
# 2020/02/13	henry1758f 1.0.0	First Create with python instead of script

import json
import os
import string 

current_path = os.path.abspath(os.getcwd())
dump_modelinfo_path = '/opt/intel/openvino/deployment_tools/tools/model_downloader/info_dumper.py'
jsontemp_path = current_path + '/Source/model_info.json'
model_path = '~/openvino_models/models/SYNNEX_demo/'
ir_model_path = '~/openvino_models/ir/'

test_image_path = current_path + '/Source/testing_source/'
python_demo_path = '~/inference_engine_demos_build/intel64/Release/python_demos/action_recognition/action_recognition.py'
default_labels_path= '/opt/intel/openvino/inference_engine/demos/python_demos/action_recognition/driver_actions.txt'


action_recognition_decoder_model = ['driver-action-recognition-adas-0002-decoder','action-recognition-0001-decoder']
action_recognition_encoder_model = ['driver-action-recognition-adas-0002-encoder','action-recognition-0001-decoder']

default_source = '0'
default_arg = ' -m_en ' + model_path + 'intel/driver-action-recognition-adas-0002-encoder/FP32/driver-action-recognition-adas-0002-encoder.xml' + \
' -m_de ' + model_path + 'intel/driver-action-recognition-adas-0002-decoder/FP32/driver-action-recognition-adas-0002-decoder.xml' + \
' -i ' + default_source + \
' -d CPU  ' + \
' -lb ' + default_labels_path

if os.path.isfile(jsontemp_path):
	os.system('rm -r ' + jsontemp_path)
os.system(dump_modelinfo_path + " --all >> " + jsontemp_path)

def check_jsontemp_exist():
	if not os.path.isfile(jsontemp_path):
		print('[ ERROR ] ' + jsontemp_path + ' is not exist! ')
		return False
	else:
		return True

def terminal_clean():
	os.system('clear')

def banner():
	print("|=========================================|")
	print("|         Action Recognition Demo         |")
	print("|=========================================|")
	print("|  Support OpenVINO " + os.popen('echo $VERSION_VINO').read() )
	print("")

def target_device_select():
	return input('\n [Typein the target device for inference this model (CPU,GPU,MYRIAD,HDDL,etc.)]  >> ')

def precisions_select(precisions_item,name):
	i = 0
	for result in precisions_item:
		i += 1
		print(str(i) + '. [' + result + ']' )
	else:
		keyin = input('\n [Select precisions of the model "' + name + '"]  >>')
		i = 0
		for result in precisions_item:
			i += 1
			if str(i) == keyin or keyin == result:
				return result
				break
		else:
			print('[ ERROR ] ')
			return


def model0_select(dldt_search_str, welcome_str, arg_tag):
	print(welcome_str)
	if check_jsontemp_exist() :
		global jsonObj_Array
		with open(jsontemp_path,'r') as input_file:
			jsonObj_Array = json.load(input_file)
		i = 0
		print('\n===== Model List =====')
		for name in dldt_search_str:
			for item in jsonObj_Array:
				if name in item['name']:
					i += 1
					precisions_string = ''
					for precisions in item['precisions']:
						precisions_string = precisions_string + '[' + precisions +']'
					print(str(i) + '. ' + item['name'] + '\t\t' + precisions_string + '\n\t\t[' + item['framework'] + '] ' + item['description'] )
	select = input('Select a number Or input a path to your model  >> ')
	if check_jsontemp_exist() :
		i = 0
		for name in dldt_search_str:
			for item in jsonObj_Array:
				if name in item['name']:
					i += 1
					if str(i) == select:
						precisions = precisions_select(item['precisions'],item['name'])
						#device = target_device_select()
						if 'intel/' in item['subdirectory']:
							Path = model_path + item['subdirectory'] + '/' + str(precisions) + '/' + item['name'] + '.xml'
						elif 'public/' in item['subdirectory']:
							Path = ir_model_path + item['subdirectory'] + '/' + str(precisions) + '/' + item['name'] + '.xml'
						print('[ INFO ] [ ' + item['name'] + ' ][' + str(precisions) + '] been selected')
						print('> Path: ' + Path)
						return ' -m' + arg_tag + Path + ' -d' + arg_tag# + device
					elif select == '' :
						return ''

def source_select():
	source = input(' \n\n[ For using default Source, just press ENTER, \n\tor typein the path to the source you want. \n]\n  >> ')
	if source == '':
		return default_source
	else:
		return source

def label_select():
	label = input('\n\n[ Please input the label path , for using driver_actions.txt,press ENTER(Default) ]\n  >> ')
	if label == '':
		return ' -lb ' + default_labels_path
	else:
		return ' -lb ' + label

def excuting():
	global arguments_string
	arguments_string = ''
	source = default_source
	label = default_labels_path
	arguments_string += model0_select(action_recognition_encoder_model,  ' [Select a encoder model.]', '_en ')
	if arguments_string == '':
		print('[ INFO ] Load Default Configuration...')
		arguments_string = default_arg
	else:
		select_str = ''
		select_str = model0_select(action_recognition_decoder_model,  ' [Select a decoder model.]', '_de ')
		if select_str == '':
			select_str = ' -m_de ' + model_path + 'intel/driver-action-recognition-adas-0002-decoder/FP32/driver-action-recognition-adas-0002-decoder.xml'
		arguments_string +=select_str
		label = label_select()
		source = source_select()
		arguments_string += ' -i ' + source + label
		device = target_device_select()
		if device == '':
			device = 'CPU'
		arguments_string += ' -d ' + device
	excute_string =  'python3 ' + python_demo_path + arguments_string
	if not os.path.isfile(python_demo_path):
		os.system('cp -r /opt/intel/openvino/inference_engine/demos/python_demos $DEMO_LOC')
	print('[ INFO ] Running > ' + excute_string)
	os.system(excute_string)


###########
terminal_clean()
banner()
excuting()

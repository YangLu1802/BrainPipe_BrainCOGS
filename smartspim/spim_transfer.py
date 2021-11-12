import os,sys
import xml.etree.ElementTree as ET


def transfer_placetiles(raw_dir_ch1,raw_dir_ch2):
	""" Copy over xml_placetiles.xml from raw_dir_ch1
	to raw_dir_ch2 and modify the two header lines to point to raw_dir_ch2
	"""
	ch1_placetiles_file = os.path.join(raw_dir_ch1,'xml_placetiles.xml')
	ch2_placetiles_file = os.path.join(raw_dir_ch2,'xml_placetiles.xml')
	
	with open(ch1_placetiles_file, encoding="utf8") as f:
		tree = ET.parse(f)
		root = tree.getroot()

		for elem in root.getiterator():
			if elem.tag == 'stacks_dir' or elem.tag == 'mdata_bin':
				ch1_value = elem.get('value')
				elem.set('value',ch1_value.replace(raw_dir_ch1,raw_dir_ch2))
				# print(elem.get('value'))

	tree.write(ch2_placetiles_file, encoding='utf8')
	print(f"Saved {ch2_placetiles_file}")
	return 

if __name__ == "__main__":

	#get jobids from SLURM or argv
	raw_dir_ch1 = sys.argv[1]
	raw_dir_ch2 = sys.argv[2]

	transfer_placetiles(raw_dir_ch1,raw_dir_ch2)

<?php
	error_reporting(E_ALL ^ E_NOTICE);
	
    //the php file must be recognized as XML document so necessary header sent
    header("Content-type:text/xml");
    //default xml file header (UTF-8 is a common value, but in some cases another encoding must be used)
    print('<?xml version="1.0" encoding="UTF-8"?>');

    //the script receive a parent item id from GET scope as my_script.php?id=PARENT_ID
    //if parent id not sent - top level in related sample - then  set it equal to 0
    if (!isset($_GET['id']))  $_GET['id']=0;
    //write top tag of xml document, the parent attribute contain id of parent row
    print ("<rows parent='".$_GET['id']."'>");

	for ($j=0; $j<10; $j++){
        print "<row open='1' id='b_{$_GET['id']}_{$j}' xmlkids='".(($i%4==0)?1:"")."'><cell >top{$j}</cell>";
    //in real code here you must take records from DB
    //in sample we simple create a 20 dummy records
    for($i = 0;$i<10;$i++){
        //row tag contain a id and xmlkids attributes
        //if xmlkids attribute exists and is not empty - the row will be drawn as expandable
        //in our sample each 4th row will be expandable
        print "<row id='a_{$_GET['id']}_{$i}_{$j}' xmlkids='".(($i%4==0)?1:"")."'>";
        //value of row
        print ("<cell image='folder.gif'>Item {$_GET['id']}:{$i}</cell><cell>Item {$_GET['id']}</cell>");
		for($z = 0;$z<3;$z++){
           print "<row id='a_{$_GET['id']}_{$i}_{$j}_{$z}' ><cell>Item {$_GET['id']}:{$i}:{$z}</cell></row>";
		}
        //close row tag
        print ("</row>");
    }
   print ("</row>");
	}
    //after drawing all childs of current row, the main tag must be closed
    print("</rows>");

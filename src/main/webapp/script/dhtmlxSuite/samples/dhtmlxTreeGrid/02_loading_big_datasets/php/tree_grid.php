<?php
	error_reporting(E_ALL ^ E_NOTICE);
	
	header("Content-type:text/xml");
	echo "<?xml version='1.0' ?><rows>";


	function a_row($pid,$ind,$lev){
		global  $on_level;
		global  $levels;
		global  $each;
		global  $columns;

		$id=$pid."_".$lev."_".$ind;
		echo "<row id='".$id."'>";
		for ($i=0; $i<$columns; $i++)
			echo "<cell> ".$id." - c".$i."</cell>";

		if  (($levels>$lev)&&(($ind%$each)==1))
			for ($i=0; $i<$on_level; $i++){
    	        echo a_row($id,$i,$lev+1);
				echo "</row>";
			}

	}
	$on_level=20;
	$levels=3;
	$each=5;
	$columns=5;
	for ($i=0; $i<$on_level; $i++){
		echo a_row("x",$i,0);
		echo "</row>";
	}

?>



</rows>


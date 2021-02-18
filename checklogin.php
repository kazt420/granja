<?php
session_start();

include("php/conexion.php");

$datos = json_decode(file_get_contents("php://input"));
$username = $datos->{'user'};
$password = $datos->{'pass'};
 
$sql = "call login('$username', '$password')";
$result = $conexion->query($sql);
 $result->num_rows;

if ($result->num_rows) { 

 $row = $result->fetch_array(MYSQLI_ASSOC);
		  if ($row['state']==1) 


		  { 
		    $_SESSION['loggedin'] = true;
		    $_SESSION['username'] = $username;
		    // $_SESSION['nombre'] = $row['usuario'];
		    // $_SESSION['start'] = time();
		    // $_SESSION['expire'] = $_SESSION['start'] + (50 * 60);
		    //header ("Location: administracion.php"); 
		    echo json_encode(array('IdEmpleado' =>$row['IdEmpleado'], 'Tipo' => $row['Tipo']));

		   
		  } 

		 else { 
		    echo 0;
		 }
}
else { 

		    echo 0;
 }

 mysqli_close($conexion); 
 ?>
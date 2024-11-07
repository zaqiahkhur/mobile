<?php
$conn=new mysqli("localhost","root","","peminjamanbarang");
$query=mysqli_query($conn,"SELECT * FROM admin");
$data = mysqli_fetch_all($query, MYSQLI_ASSOC);
echo json_encode($data);
?>
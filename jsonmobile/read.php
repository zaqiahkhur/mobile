<?php
$conn=mysqli_connect("localhost","root","","peminjamanbarang");
$query=mysqli_query($conn,"select * from barang");
$data = mysqli_fetch_all($query, MYSQLI_ASSOC);
echo json_encode($data);
?>
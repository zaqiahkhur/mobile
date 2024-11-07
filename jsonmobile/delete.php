<?php
$conn=mysqli_connect("localhost","root","","peminjamanbarang");
$id = $_POST['id'];
$data = mysqli_query($conn, "delete  from barang where id=$id");
if ($data) {
    echo json_encode([
        "pesan" => "sukses"]);
}else {
    echo json_encode([
        "pesan" => "gagal"]);
}
?>
# Tutorial 3 - Introduction to Game Programming
## Ramadhan Andika Putra (2206081976) - GameDev A <br>

### Latihan Mandiri: Eksplorasi Mekanika Pergerakan

#### *Double jump*
> Saya mengimplementasikan *double jump* dengan memanfaatkan variabel `jump_count` yang di-*reset* setiap kali karakter menyentuh lantai, sehingga ketika tombol **ui_up** ditekan dua kali, kode di bagian `if jump_count == 1 and !is_on_floor() and Input.is_action_just_pressed('ui_up'):` akan mengatur `velocity.y` ke nilai `jump_speed` dan menaikkan `jump_count` ke 2 dan memberikan efek lompatan kedua yang ekstra.
<br>

#### *Dashing*
> Saya mengimplementasikan *dashing* dengan mendeteksi *double press* pada tombol arah menggunakan perbandingan waktu antara input dengan variabel `last_press_time` dan `double_press_threshold`, sehingga ketika tombol `ui_left` atau `ui_right` ditekan dua kali secara cepat, fungsi `start_dash(direction)` dipanggil. Di dalam fungsi tersebut, saya mengatur `is_dashing` ke true dan menyetel `dash_timer` ke nilai `dash_duration`, yang menentukan seberapa lama mode *dash* akan aktif. Selama periode *dash*, pada setiap *frame* di fungsi `_physics_process(delta)`, `dash_timer` berkurang dengan nilai delta, sehingga ketika *timer* mencapai nol atau ketika tombol arah tidak lagi ditekan, *dash* dinonaktifkan dengan menyetel `is_dashing` menjadi *false*.
<br>

#### *Crouching*
> Saya mengimplementasikan *crouching* dengan mengubah tampilan *sprite* dan mengatur kecepatan gerak melalui blok `if Input.is_action_pressed("ui_down"):`. Di situ, saya mengubah tekstur karakternya ke `crouch_texture`, mengecilkan ukuran *sprite* dengan `sprite.scale = Vector2(0.8, 0.8)`, dan menyesuaikan *collision shape* dengan `collision_shape.scale = Vector2(0, 0)` agar area tumbukan sesuai dengan postur saat *crouching*. Selain itu, ketika karakter dalam posisi *crouch*, kecepatannya dihitung menggunakan `crouch_speed` sehingga gerakannya menjadi lebih lambat.<br>

<br>

### *Polishing* Sederhana

#### Memperbaiki *sprite* karakter sehingga tampilannya sesuai dengan arah jalannya karakter
> Saya mengimplementasikan perbaikan *sprite* berdasarkan arah gerak dengan memanfaatkan properti `flip_h` pada *node sprite*. Ketika tombol arah ditekan, terdapat blok kode yang mengatur `sprite.flip_h = true` untuk gerak ke kiri atau `sprite.flip_h = false` untuk gerak ke kanan agar *sprite* secara otomatis menghadap ke arah tombol ditekan, sehingga karakter selalu menghadap ke arah gerakan. Pendekatan ini memastikan orientasi karakter tetap konsisten, sehingga dapat memudahkan pemain dalam mengidentifikasi arah pergerakan.
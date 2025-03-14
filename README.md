# Table of Contents
- [Tutorial 3 - Introduction to Game Programming](#tutorial-3---introduction-to-game-programming)
- [Tutorial 5 - Assets Creation & Integration](#tutorial-5---assets-creation--integration)
<br>


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

<br>
<br>


# Tutorial 5 - Assets Creation & Integration
## Ramadhan Andika Putra (2206081976) - GameDev A <br>

### Latihan Mandiri: Membuat dan Menambah Variasi Aset

#### 1 (satu) objek baru di dalam permainan yang dilengkapi dengan animasi menggunakan *spritesheet* selain yang disediakan tutorial
> Saya membuat objek baru berupa `Yeti` menggunakan *node* *CharacterBody2D* sebagai *root* dan menambahkan *node* *AnimatedSprite2D* sebagai *child*. Saya men-*download* *spritesheet* dari [Spriters Resource](https://www.spriters-resource.com/pc_computer/spelunky2/sheet/182551/) dan membuat *resource* *SpriteFrames* yang berisi animasi 'idle', 'marah', dan 'kabur'. Saya kemudian mengatur properti seperti `flip` dan `scale` agar visual Yeti dapat sesuai dengan yang saya diharapkan, serta menambahkan *node* *Area2D* beserta *CollisionShape2D* untuk mendeteksi tabrakan dengan `Player`. Dalam *script* `Yeti.gd`, saya menambahkan *logic* untuk memeriksa apakah `Player` sedang melakukan *dash*, sehingga jika *True*, animasi berubah ke 'kabur' dan Yeti bergerak ke kanan. Jika tidak, animasi Yeti berubah ke 'marah' dan memukul `Player`, lalu *scene* berganti ke *gameover.tscn*.<br>

#### 1 (satu) audio untuk efek suara (SFX) dan memasukkannya ke dalam permainan
> Saya menambahkan untuk efek suara (SFX) dengan cara menambahkan dua node *AudioStreamPlayer2D* di dalam objek `Yeti`. Salah satunya digunakan untuk memainkan suara *'[angry Yeti](https://www.youtube.com/shorts/5quVpw_xdO0)'* saat animasi 'marah' aktif, sedangkan yang satunya lagi dipakai untuk memainkan suara *['Crying Bear'](https://www.youtube.com/watch?v=p_ipufZVxEY)* (gak nemu suara Yeti nangis) ketika Yeti terkena *dash* dari pemain sehingga animasi berubah menjadi 'kabur'. Saya mengatur file audio yang sesuai melalui *Inspector* dan menggunakan pengecekan menggunakan properti *playing* agar audio tidak diputar berulang-ulang jika sudah aktif.<br>

#### 1 (satu) musik latar (background music) dan memasukkannya ke dalam permainan
> Saya menambahkan musik latar *(background music)* dengan menambahkan node *AudioStreamPlayer2D* pada `Main.tscn` dan mengatur properti seperti `Stream` dan `Loop` agar musik yang saya ambil dari [YouTube](https://www.youtube.com/watch?v=huyKDugjYWc)tersebut otomatis diputar saat permainan dimulai dan terus *looping* jika musiknya selesai. Saya juga mengatur level volume agar sesuai dengan atmosfer pegunungan es yang saya inginkan. Seluruh proses implementasinya saya kerjakan mengikuti tutorial, sehingga musiknya berjalan secara harmonis dengan latar *scene* yang ada.<br>

#### Implementasikan interaksi antara objek baru tersebut dengan objek yang dikendalikan pemain
> Saya mengimplementasikan interaksi dengan membuat *logic* di dalam *script* `Yeti.gd` sehingga ketika Player bersentuhan dengan Yeti melalui *node* `Area2D`, sistem akan memeriksa apakah Player sedang melakukan *dash*. Jika Player tidak sedang *dash*, maka Yeti akan memainkan animasi 'marah' dan "memukul" Player yang kemudian mengakibatkan transisi ke *scene* `gameover.tscn` yang menandakan permainan selesai. Namun, jika Player sedang melakukan *dash*, Yeti akan memainkan animasi 'kabur' dan pergi meninggalkan layar permainan. *Logic* ini saya implementasikan dengan memanfaatkan fungsi `_on_area_2d_body_entered(body)` yang mengecek properti `is_dashing` dari `Player` untuk menentukan respon Yeti.<br>

#### Implementasikan audio feedback dari interaksi antara objek baru dengan objek pemain
> Saya menambahkan* audio feedback* dengan menempatkan dua *node* `AudioStreamPlayer2D` di dalam objek Yeti. Saya mengonfigurasi salah satunya untuk memainkan suara *'angry Yeti'* ketika animasi 'marah' aktif, dan yang lainnya untuk memainkan suara *'Crying Bear'* ketika Yeti masuk ke mode 'kabur' akibat interaksi dengan Player yang sedang *dash*. Di dalam fungsi pada *script* `Yeti.gd`, saya memastikan audio hanya diputar jika belum aktif dengan memeriksa properti `playing`, sehingga memberikan sinyal audio yang konsisten tanpa mengganggu pengalaman bermain.

### *Polishing* Sederhana

####  Mengganti Logic pada Player Menggunakan AnimatedSprite2D
> Saya mengupdate *logic* pada player dengan menggantikan penggunaan `Sprite2D` dan pengaturan `texture` secara langsung dengan penggunaan `AnimatedSprite2D`. Saya mengimpor *custom spritesheet* dan membuat resource `SpriteFrames` yang berisi animasi seperti 'idle', 'jump', 'dash', dan 'crouch'. Saya mengimplementasikan fungsi `anim_set(animation)` untuk mengecek apakah animasi yang aktif sudah sama dengan animasi yang akan diputar, sehingga transisi antar animasi terjadi secara natural tanpa terjadi *restart* animasi yang tidak diinginkan.<br>

#### Implementasi Interaksi Ganda antara Player dan Yeti
> Saya mengimplementasikan dua jenis interaksi antara Player dan Yeti di *script* `Yeti.gd`. Saat Player bertabrakan dengan Yeti melalui *node* `Area2D`, *script mengecek apakah Player sedang dalam kondisi *dash*. Jika Player sedang dash, Yeti akan memainkan animasi 'kabur' dan pergi meninggalkan layar permainan. Namun, jika Player tidak *dash*, Yeti akan memainkan animasi 'marah' yang mengindikasikan bahwa Yeti memukul Player hingga *game over*. *Logic* ini saya buat dengan memanfaatkan pengecekan properti `is_dashing` dari Player serta penggunaan node `Area2D` untuk mendeteksi tabrakan.<br>

#### Menambahkan Background di Main.tscn
> Untuk menambahkan *background* pada *scene* utama, saya menambahkan node `TextureRect` ke dalam `Main.tscn` dan mengatur *anchor*-nya agar memenuhi seluruh layar. Saya mengimpor *background image* yang sesuai dengan tema permainan, yaitu suasana pegunungan es dan memastikan properti `Expand` aktif sehingga gambar dapat menyesuaikan ukuran layar dengan baik. Pendekatan ini saya gunakan agar tampilan visual lebih menarik dan mendukung latar game yang saya kembangkan

### Sumber Asset:
* https://www.spriters-resource.com/pc_computer/spelunky2/sheet/182551/
* https://www.youtube.com/shorts/5quVpw_xdO0
* https://www.youtube.com/watch?v=p_ipufZVxEY
* https://www.youtube.com/watch?v=huyKDugjYWc
* [DALL·E](https://openart.ai/) (untuk *background* pada *scene* utama)
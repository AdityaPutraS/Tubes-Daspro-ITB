unit fitur;

interface
	uses tambahan, sysutils;
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran : longint;tanggal : AnsiString);
	procedure lihatInventori (listInvMentah, listInvOlahan: strukDat);// menampilkan data daftar bahan mentah dan bahan olahan yang tersedia di inventori saat ini terurut membesar menurut nama bahan
	procedure lihatResep (daftarResep: strukDat); //menampilkan data daftar resep yang tersedia beserta penyusunnya dengan terurut membesar
	procedure istirahat (var countIst:integer); //menambah energi sebanyak 1 buah, maksimum istirahat 6 kali sehari, energi maksimum 10
	procedure makan (var countMakan:integer); //menambah energi sebanyak 3 buah, maksimum makan 3 kali sehari, energi maksimum 10 
	procedure cariResep(daftarResep:strukDat);
	procedure tidur(var tanggal:AnsiString;var hariLewat,energi:longint;daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;var sudahTidur:boolean);
	
implementation
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran : longint;tanggal : AnsiString);
	//beli bahan sesuai spek soal.
	var
		namaB : AnsiString;
		i,indeksInv : longint;
		kuantitas,harga,stok : longint;
		ketemu : boolean;
	begin
		write('> Nama Bahan : ');readln(namaB);
		write('> Kuantitas : ');readln(kuantitas);
		//cari namaBahan di list bahan dengan skema searching mengunakkan boolean
		ketemu := false;
		i := 0;
		while((i <= High(daftarBahMentah)) and (not(ketemu))) do begin
			if(LowerCase(daftarBahMentah[i][0]) = LowerCase(namaB)) then begin
				ketemu := true;
			end;
			i += 1;
		end;
		//jika ketemu, indeks sebenarnya dari item adalah i-1, jadi kita buat i = i-1
		if(ketemu) then begin
			i := i-1;
			//cek apakah stok cukup
			val(daftarBahMentah[i][2],stok); //val berguna untuk merubah string menjadi integer, syntaknya val(s,i) lalu string s akan diubah menjadi integer dan disimpan di i
			if(stok>=kuantitas) then begin
				//cek apakah inventori muat
				if(High(listInvMentah)+High(listInvOlahan)+1<=maksInv) then begin	//high berguna untuk mengembalikkan indeks terakhir dari suatu array
					//sukses beli
					val(daftarBahMentah[i][1],harga);
					writeln(kuantitas*harga);
					totPengeluaran += (kuantitas * harga);
					stok -= kuantitas;
					str(stok,daftarBahMentah[i][2]);
					//memasukan barang yang baru dibeli ke inventori
						//mengatur panjang baru dari listInvMentah
						SetLength(listInvMentah,Length(listInvMentah)+1);
						indeksInv := High(listInvMentah);
						SetLength(listInvMentah[indeksInv],3);
						//memasukkan ke array listInvMentah
						listInvMentah[indeksInv][0] := daftarBahMentah[i][0];
						listInvMentah[indeksInv][1] := tanggal;
						str(kuantitas,listInvMentah[indeksInv][2]);
					writeln('Pembelian sukses.');
				end else begin
					//gagal beli
					writeln('Pembelian barang gagal karena inventori tidak cukup.');
				end;
			end else begin
				writeln('Pembelian barang gagal karena stok di supermarket tidak cukup.');
			end;
		end else begin
			writeln('Pembelian barang gagal karena bahan tidak ada di supermarket.');
		end;
		energi -= 1;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure lihatInventori (listInvMentah, listInvOlahan: strukDat);
		//Kamuslokal
	var
		i,j:integer; //increment
	//Algoritma
	begin
		urut(listInvMentah);//mengurutkan invMentah
		urut(listInvOlahan);//mengurutkan invOlahan
		writeln('Inventori bahan Mentah');
		for i:=0 to length(listInvMentah)-1 do //menuliskan ke layar
		begin
			for j:=0 to length(listInvMentah[i])-1 do
			begin
				write(listInvMentah[i][j]);
				if j<> length(listInvMentah[i])-1 then write(' | ');
			end;
			writeln();
		end;
		writeln('inventori bahan olahan');
		for i:=0 to length(listInvOlahan)-1 do //menuliskan ke layar
		begin
			for j:=0 to length(listInvOlahan[i])-1 do
			begin
				write(listInvOlahan[i][j]);
				if (j<> length(listInvOlahan[i])-1) then write(' | ');
			end;
			writeln();
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure lihatResep (daftarResep: strukDat);
	//Kamuslokal
	var
		i,j:integer; //increment
	//Algoritma
	begin
		urut(daftarResep);// mengurutkan daftarResep
		writeln('Daftar Resep');
		for i:=0 to length(daftarResep)-1 do //menuliskan ke layar
		begin
			for j:=0 to length(daftarResep[i])-1 do
			begin
				write(daftarResep[i][j]);
				if j<> length(daftarResep[i])-1 then write(' | ');
			end;
			writeln();
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure istirahat(var countIst:integer;var energi : longint);
	//algoritma 
	begin
		if (countIst<6) and (energi < 10) then
		begin
			energi += 1;
			countIst += 1;
		end else begin //countIst >= 6 atau energi > 10
			if (countIst = 6)then
			begin
				writeln('Sudah istirahat 6 kali');
			end else begin 
				writeln('Energi mencapai batas maksimum');
			end;
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure makan (var countMakan, energi : longint);
	//algoritma
	begin
		if (countMakan<3) and (energi + 3 <= 10) then
		begin
			energi:= energi + 3;
			countMakan:= countMakan +1;
		end else begin //countMakan > 3 atau energi > 7
			if (countMakan = 3 ) then
			begin
				writeln('Sudah makan 3 kali');
			end else begin
				energi :=10;
				writeln('Batas maks energi 10');
			end;
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure cariResep(daftarResep:strukDat);
	//cari resep dari file daftarResep
	var
		namaR:ansiString;
		ketemu:boolean;
		i,j:longint;
	begin
		write('> Nama Resep : ');readln(namaR);
		ketemu:=false;
		i:=0;
		while(i<=High(daftarResep)) and (not ketemu) do
		begin
			if (LowerCase(daftarResep[i][0]) = LowerCase(namaR)) then
			begin
				ketemu:=true;
			end;
			i+=1;
		end;
		if ketemu then 
		begin
			i-=1;
			write('Nama Resep : ');writeln(daftarResep[i][0]);
			write('Harga Jual : ');writeln(daftarResep[i][1]);
			write('Banyak Bahan Digunakan : ');writeln(daftarResep[i][2]);
			writeln('Bahan yang Digunakan : ');
			for j:=3 to high(daftarResep[i]) do
			begin
				writeln('-',daftarResep[i][j]);
			end;
		end else begin
			writeln('Resep tidak ditemukan.');	
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure tidur(var tanggal:AnsiString;var hariLewat,energi:longint;daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;var sudahTidur:boolean);
	var
		tglb,sekarang:penanggalan;
		i,j,durasi:longint;
	begin
		if sudahTidur then
		begin
			writeln('Tidur gagal karena Anda baru saja tidur.');
		end else begin
			ambilHari(tanggal,sekarang);
			for i:=0 to high(listInvOlahan) do
			begin
				ambilHari(listInvOlahan[i][1],tglb);
				if ((sekarang.h-tglb.h)=3) then delStrukDat(listInvOlahan,i)
			end;
			for i:=0 to high(listInvMentah) do
			begin
				for j:=0 to high(daftarBahMentah) do 
				begin
					if (daftarBahMentah[j][0]=listInvMentah[i][0]) then durasi:=strtoint(daftarBahMentah[j][2]);
				end;
				ambilHari(listInvMentah[i][1],tglb);
				if ((sekarang.h-tglb.h)=durasi) then delStrukDat(listInvMentah,i)
			end;
			hariLewat+=1;
			energi:=10;
			sudahTidur:=true;
			tambahHari(tanggal);
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure tambahresep (var energi : longint;var daftarResep : strukDat;daftarBahMentah,daftarBahOlahan : strukDat);
	//KAMUS LOKAL
	var
		neff, i ,hargabeli : longint; //menyimpan harga bahan mentah total untuk membuat resep
		namaResep : AnsiString;
	//ALGORITMA
	begin
		//verifikasi apakah energi masih ada
		if (energi=0) then
		begin
			write('Energi tidak mencukupi untuk menambah resep, silahkan tambah energi !');
		end else
		begin
			//Menambah panjang array dinamis
			SetLength(daftarResep, length(daftarResep)+1);
			SetLength(daftarResep[High(daftarResep)], length(daftarResep[High(daftarResep)])+1);
			neff := High(daftarResep); //neff berisi indeks tertinggi sekarang
			write('Masukkan nama resep : '); readln(namaResep);
			//validasi apabila nama sudah dimasukkan atau belum
			if isThere(namaResep, daftarResep)= True then //kondisi if bernilai true apabila ada nama bahan pada daftarResep
			begin
				repeat
					writeln('Nama resep telah dimasukkan sebelumnya. Ulangi !');
					write('Masukkan nama resep : ');
					readln(namaResep); // input ulang dari user
				until (not(isThere(namaResep, daftarResep)));
			end;
			daftarResep[neff][0] := namaResep;
			//input jumlah bahan dan bahan-bahannya
			write('Jumlah bahan = ');
			readln(daftarResep[neff][2]); //input jumlah bahan
			if StrToInt(daftarResep[neff][2])<2 then
			//validasi, jumlah bahan harus >=2
				begin
					repeat
						writeln('Jumlah bahan harus >=2');
						write('Jumlah bahan = ');
						readln(daftarResep[neff][2]);
					until (StrToInt(daftarResep[neff][2])>=2);
				end;
			hargabeli:=0; // akan digunakan untuk menyimpan penjumlahan dari semua harga barang mentah
			writeln('Masukkan bahan-bahan :');
			for i:=3 to (strtoint(daftarResep[neff][2]) + 2) do
			begin
				write('Bahan ke-',(i-2),' : '); //menghasilkan Bahan ke-n (n : 1,2,3,4,5)
				readln(daftarResep[neff][i]); // i karena bahan mulai dari indeks ke 3 sampai akhir, sehingga cocok dengan i
				//validasi apakah bahan mentah ada pada inventori bahan mentah
				if (isThere(daftarResep[neff][i],daftarBahMentah) = False) and (isThere(daftarResep[neff][i],daftarBahOlahan) = False) then
				begin
					repeat
						writeln('Bahan tidak ada pada file inventori bahan mentah dan bahan olahan, masukkan bahan kembali!');
						write('Bahan ke-',i,' : ');
						readln(daftarResep[neff][i]); 
					until ( (isThere(daftarResep[neff][i],daftarBahMentah)) or (isThere(daftarResep[neff][i],daftarBahOlahan)) ) ;
				end;
				//mencari harga beli bahan
				hargabeli:=hargabeli + hargaBahan(daftarResep[neff][i],daftarBahMentah) + hargaBahan(daftarResep[neff][i],daftarBahOlahan); //jika bahan ada di bahanMentah, 
																																			//tidak apa apa memanggil hargaBahan(daftarResep....,daftarBahOlahan)
																																			//karena itu akan mereturn 0, sehingga tidak berpengruh
			end;
			//input harga jual
			write('Masukkan harga jual dari makanan');
			readln(daftarResep[neff][1]); //input harga jual
			//validasi apakah harga jual lebih dari 12.5 persen dari harga beli
			if (StrToInt(daftarResep[neff+1][1]) < 1.25*hargabeli) then
			begin
				repeat
					writeln ('Harga jual harus minimal 12.5 persen lebih daripada total harga bahan mentah ! ');
					write('Masukkan harga jual dari makanan : ');
					readln(daftarResep[neff][1]); //input harga jual
				until (StrToInt(daftarResep[neff][1]) >= 1.25*hargabeli);
			end;
			writeln('Resep berhasi di masukkan');
		end;
		energi -= 1;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure upgradeinventori (var energi,maksInv,totUang : longint;);
	begin
		//verifikasi apakah energi cukup
		if energi = 0 then
		begin
			write('Energi tidak mencukupi untuk menambah resep, silahkan tambah energi !');
		end else
		begin
			if (hargainventori < totUang) then
			begin
				totUang := totUang - hargainventori;
				maksInv := maksInv + 25; {penambahan 25 terhadap maksimal inventori ketika prosedur ini dijalankan}
				writeln('Transaksi berhasil, kapasitas inventori bertambah');
			end else
				writeln ('Transaksi gagal, uang tidak cukup');
		end;
		energi -= 1;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end.
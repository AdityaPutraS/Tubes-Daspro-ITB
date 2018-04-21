unit fitur;

interface
	uses tambahan, sysutils;
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran,energi,totUang : longint;tanggal : AnsiString;hariLewat : longint;var sudahTidur:boolean);
	procedure lihatInventori (listInvMentah, listInvOlahan: strukDat;var sudahTidur:boolean);// menampilkan data daftar bahan mentah dan bahan olahan yang tersedia di inventori saat ini terurut membesar menurut nama bahan
	procedure lihatResep (daftarResep: strukDat;var sudahTidur:boolean); //menampilkan data daftar resep yang tersedia beserta penyusunnya dengan terurut membesar
	procedure istirahat(var countIst:longint;var energi : longint;var sudahTidur:boolean);//menambah energi sebanyak 1 buah, maksimum istirahat 6 kali sehari, energi maksimum 10
	procedure makan (var countMakan, energi : longint;var sudahTidur:boolean); //menambah energi sebanyak 3 buah, maksimum makan 3 kali sehari, energi maksimum 10 
	procedure cariResep(daftarResep:strukDat;var sudahTidur:boolean);
	procedure tidur(var tanggal:AnsiString;var hariLewat,energi:longint;daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;var sudahTidur:boolean);
	procedure tambahresep (var daftarResep : strukDat;daftarBahMentah,daftarBahOlahan : strukDat;var sudahTidur:boolean);	
	procedure upgradeinventori (maksInv,totUang : longint;var sudahTidur:boolean);
	procedure lihatStatistik(status,listInvMentah,listInvOlahan:strukdat;var sudahTidur:boolean);
	procedure olahBahan(var energi, totBOlahanBuat:longint;maksInv:longint;daftarBahOlahan,daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;tanggal:ansiString;hariLewat : longint;var sudahTidur:boolean);
	procedure jualOlahan (var energi, totPemasukan,totBOlahanJual,totUang : longint; var listInvOlahan : strukDat; daftarBahOlahan : strukDat;var sudahTidur:boolean);
	procedure jualResep (var energi, totPemasukan,totResepJual,totUang : longint; var listInvOlahan, listInvMentah : strukDat; daftarResep : strukDat;var sudahTidur:boolean);
implementation
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran,energi,totUang : longint;tanggal : AnsiString;hariLewat : longint;var sudahTidur:boolean);
	//beli bahan sesuai spek soal.
	var
		i,j,stok,kuantitas,harga,indeksInv : longint;
		namaB : AnsiString;
		tanggalSekarang : AnsiString;
	begin
		if(energi > 0) then begin
			write('Nama Bahan : ');readln(namaB);
			write('Kuantitas : ');readln(kuantitas);
			energi -= 1;
			sudahTidur:=false;
			i := idxStrukDat(namaB,daftarBahMentah,0);
			if(not(i = -1)) then begin
				//cek apakah stok cukup
				val(daftarBahMentah[i][2],stok); //val berguna untuk merubah string menjadi integer, syntaknya val(s,i) lalu string s akan diubah menjadi integer dan disimpan di i
				if(stok>=kuantitas) then begin
					//cek apakah inventori muat
					if((length(listInvMentah)+length(listInvOlahan))<=maksInv) then begin	//high berguna untuk mengembalikkan indeks terakhir dari suatu array
						val(daftarBahMentah[i][1],harga);
						if((kuantitas*harga) <= totUang) then begin
							write('Total bayar : ');writeln(kuantitas*harga);
							totPengeluaran += (kuantitas * harga);
							totUang -= (kuantitas*harga);
							stok -= kuantitas;
							str(stok,daftarBahMentah[i][2]);
							//memasukan barang yang baru dibeli ke inventori
								//mengatur panjang baru dari listInvMentah
								SetLength(listInvMentah,Length(listInvMentah)+1);
								indeksInv := High(listInvMentah);
								SetLength(listInvMentah[indeksInv],3);
								//memasukkan ke array listInvMentah
								listInvMentah[indeksInv][0] := daftarBahMentah[i][0];
								//menghitung tanggal sekarang
									tanggalSekarang := tanggal;
									for j := 0 to hariLewat do begin
										tambahHari(tanggalSekarang);
									end;
								listInvMentah[indeksInv][1] := tanggalSekarang;
								str(kuantitas,listInvMentah[indeksInv][2]);
							writeln('Pembelian sukses.');
						end else begin
							writeln('Pembelian barang gagal karena uang tidak cukup.');
						end;
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
		end else begin
			writeln('Energi tidak mencukupi');
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure lihatInventori (listInvMentah, listInvOlahan: strukDat;var sudahTidur:boolean);
		//Kamuslokal
	var
		i,j:integer; //increment
	//Algoritma
	begin
		urut(listInvMentah);//mengurutkan invMentah
		urut(listInvOlahan);//mengurutkan invOlahan
		writeln('Inventori bahan Mentah : ');
		for i:=0 to length(listInvMentah)-1 do //menuliskan ke layar
		begin
			write('	');	//Memberi tab
			for j:=0 to length(listInvMentah[i])-1 do
			begin
				write(listInvMentah[i][j]);
				if j<> length(listInvMentah[i])-1 then write(' | ');
			end;
			writeln();
		end;
		writeln('Inventori bahan olahan');
		for i:=0 to length(listInvOlahan)-1 do //menuliskan ke layar
		begin
			write('	');	//Memberi tab
			for j:=0 to length(listInvOlahan[i])-1 do
			begin
				write(listInvOlahan[i][j]);
				if (j<> length(listInvOlahan[i])-1) then write(' | ');
			end;
			writeln();
		end;
		sudahTidur:=false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure lihatResep (daftarResep: strukDat;var sudahTidur:boolean);
	//Kamuslokal
	var
		i,j:integer; //increment
	//Algoritma
	begin
		urut(daftarResep);// mengurutkan daftarResep
		writeln('Daftar Resep');
		for i:=0 to length(daftarResep)-1 do //menuliskan ke layar
		begin
			write('	'); //Memberi tab
			for j:=0 to length(daftarResep[i])-1 do
			begin
				write(daftarResep[i][j]);
				if j<> length(daftarResep[i])-1 then write(' | ');
			end;
			writeln();
		end;
		sudahTidur:=false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure istirahat(var countIst:longint;var energi : longint;var sudahTidur:boolean);
	//algoritma 
	begin
		if (countIst<6) and (energi < 10) then
		begin
			energi += 1;
			countIst += 1;
			sudahTidur:=false;
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
	procedure makan (var countMakan, energi : longint;var sudahTidur:boolean);
	//algoritma
	begin
		if (countMakan<3) and (energi + 3 <= 10) then
		begin
			energi:= energi + 3;
			countMakan:= countMakan +1;
			sudahTidur:=false;
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
	procedure cariResep(daftarResep:strukDat;var sudahTidur:boolean);
	//cari resep dari file daftarResep
	var
		namaR:ansiString;
		i,j:longint;
	begin
		write('> Nama Resep : ');readln(namaR);
		i := idxStrukDat(namaR,daftarResep,0);
		if(not(i = -1))then 
		begin
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
		sudahTidur:=false;
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
				if ((sekarang.h-tglb.h)>=3) then delStrukDat(listInvOlahan,i)
			end;
			for i:=0 to high(listInvMentah) do
			begin
				for j:=0 to high(daftarBahMentah) do 
				begin
					if (daftarBahMentah[j][0]=listInvMentah[i][0]) then durasi:=strtoint(daftarBahMentah[j][2]);
				end;
				ambilHari(listInvMentah[i][1],tglb);
				if ((sekarang.h-tglb.h)>=durasi) then delStrukDat(listInvMentah,i);
			end;
			hariLewat+=1;
			energi:=10;
			sudahTidur:=true;
			tambahHari(tanggal);
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure tambahresep (var daftarResep : strukDat;daftarBahMentah,daftarBahOlahan : strukDat;var sudahTidur:boolean);
	//KAMUS LOKAL
	var
		neff, i ,hargabeli,panjangtemp : longint; //menyimpan harga bahan mentah total untuk membuat resep
		namaResep : AnsiString;
	//ALGORITMA
	begin
		//Menambah panjang array dinamis
		SetLength(daftarResep, length(daftarResep)+1);
		SetLength(daftarResep[High(daftarResep)], 1);//untuk menampung nama resep pada input pertama
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
		readln(panjangtemp);
		SetLength(daftarResep[neff], length(daftarResep[neff])+panjangtemp+2);
		daftarResep[neff][2]:=inttostr(panjangtemp); //input jumlah bahan
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
		for i:=3 to high(daftarResep[neff]) do
		begin
			write('Bahan ke-',(i-2),' : '); //menghasilkan Bahan ke-n (n : 1,2,3,4,5)
			readln(daftarResep[neff][i]); // i karena bahan mulai dari indeks ke 3 sampai akhir, sehingga cocok dengan i
			//validasi apakah bahan mentah ada pada inventori bahan mentah
			if (isThere(daftarResep[neff][i],daftarBahMentah) = False) and (isThere(daftarResep[neff][i],daftarBahOlahan) = False) then
			begin
				repeat
					writeln('Bahan tidak ada pada file inventori bahan mentah dan bahan olahan, masukkan bahan kembali!');
					write('Bahan ke-',(i-2),' : ');
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
		if (StrToInt(daftarResep[neff][1]) <= 1.25*hargabeli) then
		begin
			repeat
				writeln ('Harga jual harus minimal 12.5 persen lebih daripada total harga bahan mentah ! ');
				write('Masukkan harga jual dari makanan : ');
				readln(daftarResep[neff][1]); //input harga jual
			until (StrToInt(daftarResep[neff][1]) >= 1.25*hargabeli);
		end;
		writeln('Resep berhasi di masukkan');
		sudahTidur:=false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure upgradeinventori (maksInv,totUang : longint;var sudahTidur:boolean);
	const
		hargainventori = 100000;//harga yang dibutuhkan untuk upgrade inventori
	begin
		if (hargainventori < totUang) then
		begin
			totUang := totUang - hargainventori;
			maksInv := maksInv + 25; {penambahan 25 terhadap maksimal inventori ketika prosedur ini dijalankan}
			writeln('Transaksi berhasil, kapasitas inventori bertambah');
		end else
			writeln ('Transaksi gagal, uang tidak cukup');
		sudahTidur:=false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure lihatStatistik(status,listInvMentah,listInvOlahan:strukdat;var sudahTidur:boolean);
	var
		i,j: integer;
	begin
		//memunculkan data dari status pengguna
		writeln('Nomor Simulasi | Tanggal | Jumlah Hari Hidup | Jumlah Energi | Kapasitas Maksimum Inventori |Total Bahan Mentah Dibeli | Total Bahan Olahan Dibuat | Total Bahan Olahan Dijual | Total Resep Dijual | Total Pemasukan | Total Pengeluaran | Total Uang');
		for i:= 0 to (high(status[0]))do
		begin
			write(status[0][i],' ');
		end;
		writeln;
			writeln('inventory barang olahan : (Nama | Exp | jumlah)');
		for i:= 0 to (high(listInvOlahan))do
		begin
			for j:=0 to (high(listInvOlahan[i])) do
			begin
				write(listInvOlahan[i][j],' ');
			end;
			writeln;
		end;
		writeln('inventory barang mentah :(Nama | Exp | jumlah)');
		for i:= 0 to (high(listInvMentah))do
		begin
			for j:=0 to (high(listInvMentah[i])) do
			begin
				write(listInvMentah[i][j],' ');
			end;
			writeln;
		end;
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure olahBahan(var energi, totBOlahanBuat:longint;maksInv:longint;daftarBahOlahan,daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;tanggal:ansiString;hariLewat : longint;var sudahTidur:boolean);
	var
		i,j,k,idxBahan:integer;
		namaOlah, tanggalSekarang:AnsiString;
	begin
		if(energi>0) then//pengecekan apakah ada energi 
		begin 
			write('Masukkan nama olahan :');
			readln(namaOlah);
			energi -= 1;
			i := idxStrukDat(namaOlah,daftarBahOlahan,0);
			if(not(i = -1)) then begin
				//cek apakah semua bahan ada
				j := 3;
				while( (j <= high(daftarBahOlahan[i])) and (isThere(daftarBahOlahan[i][j],listInvMentah)) ) do begin
					j += 1;
				end;
				if( ((j-3) = StrToInt(daftarBahOlahan[i][2])) ) then begin
					//semua bahan ada di inventori, skrng cek apakah inv muat
					if(length(listInvMentah)+length(listInvOlahan) < maksInv) then begin //menggunakkan < bukan <=, karena kita butuh 1 slot kosong, kalo dia <= , artinya ga ada slot kosong pas total length = maksInv
						//muat, mulai kurangi 1 dari semua bahan mentah
						for j := 3 to high(daftarBahOlahan[i]) do begin
							idxBahan := idxStrukDat(daftarBahOlahan[i][j],listInvMentah,0);
							listInvMentah[idxBahan][2] := IntToStr(StrToInt(listInvMentah[idxBahan][2])-1);
							if(listInvMentah[idxBahan][2] = '0') then
								delStrukDat(listInvMentah,idxBahan);
						end;
						//masukan ke invBahanOlahan
						//cek apakah sudah ada di invBahanOlahan
						j := idxStrukDat(daftarBahOlahan[i][0],listInvOlahan,0);
						if(not(j = -1)) then begin
						//sudah ada
							listInvOlahan[j][2] := IntToStr(StrToInt(listInvOlahan[j][2])+1);
						end else begin
						//belum ada
							setLength(listInvOlahan, length(listInvOlahan)+1);
							setLength(listInvOlahan[high(listInvOlahan)], 3);
							listInvOlahan[high(listInvOlahan)][0] := daftarBahOlahan[i][0];
							//menghitung tanggal sekarang
								tanggalSekarang := tanggal;
								for k := 0 to hariLewat do begin
									tambahHari(tanggalSekarang);
								end;
							listInvOlahan[high(listInvOlahan)][1] := tanggalSekarang;
							listInvOlahan[high(listInvOlahan)][2] := '1';
						end;
						totBOlahanBuat += 1;
						writeln('Olah bahan sukses');
					end else begin
						writeln('Inventori tidak muat');
					end;
				end else begin
					writeln('Bahan mentah kurang');
				end;
			end else begin
				writeln('Nama bahan olahan tidak ditemukan');
			end;
		end	else begin
			writeln('Energi tidak mencukupi');//memunculkan pesan kelsalahan jika energi tidak mencukupi 
		end;
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure jualOlahan (var energi, totPemasukan,totBOlahanJual,totUang : longint; var listInvOlahan : strukDat; daftarBahOlahan : strukDat;var sudahTidur:boolean);
	var
		i,j : longint;
		namaOlah : AnsiString;
	begin
		if(energi > 0) then begin
			write('Masukan nama bahan olahan : ');
			readln(namaOlah);
			energi -= 1; //mengurangi energi
			i:=idxStrukDat(namaOlah, listInvOlahan, 0);
			if (not(i = -1)) then
			begin
				j := idxStrukDat(namaOlah, daftarBahOlahan, 0); 
				if(not(j = -1)) then begin
					//mengurangi 1 dari inventori, menghapus jika sudah 0
					listInvOlahan[i][2] := IntToStr(StrToInt(listInvOlahan[i][2])-1);
					if(listInvOlahan[i][2] = '0') then begin
						delStrukDat(listInvOlahan,i);
					end;
					totPemasukan += StrToInt(daftarBahOlahan[j][1]);	//menambah pemasukan
					totUang += StrToInt(daftarBahOlahan[j][1]);
					totBOlahanJual += 1;//menambah jumlah bahan olahan dijual
					writeln('Sukses jual bahan olahan');
				end else begin
					//jaga jaga aja
					writeln('Tidak bisa menemukan bahan olahan di daftar bahan olahan untuk dicari harganya');
				end;
			end else begin
				writeln('Bahan olahan tidak ditemukan di inventori');
			end;
		end else begin
			writeln('Energi tidak mencukupi');
		end;
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure jualResep (var energi, totPemasukan,totResepJual,totUang : longint; var listInvOlahan, listInvMentah : strukDat; daftarResep : strukDat;var sudahTidur:boolean);
	var
		i,j, idxBahan : longint;
		namaResep : AnsiString;
	begin
		if(energi > 0) then begin
			write('Masukan nama resep : ');
			readln(namaResep);
			energi -= 1;
			i := idxStrukDat(namaResep, daftarResep,0);
			if(not(i = -1)) then begin
				//cek apakah semua bahan ada
				j := 3;
				while( (j <= high(daftarResep[i])) and ( (isThere(daftarResep[i][j],listInvOlahan)) or (isThere(daftarResep[i][j],listInvMentah)) ) ) do begin
					j += 1;
				end;
				if ( (j-3) = StrToInt(daftarResep[i][2]) ) then begin
					//kurangi semua bahan sebanyak 1
					for j := 3 to high(daftarResep[i]) do begin
						idxBahan := idxStrukDat(daftarResep[i][j],listInvMentah,0);
						if(not(idxBahan = -1)) then begin
							//ada di inv mentah
							listInvMentah[idxBahan][2] := IntToStr(StrToInt(listInvMentah[idxBahan][2])-1);
							if(listInvMentah[idxBahan][2] = '0') then
								delStrukDat(listInvMentah,idxBahan);
						end else begin
							//ada di inv olahan <- pasti
							idxBahan := idxStrukDat(daftarResep[i][j],listInvOlahan,0);
							listInvOlahan[idxBahan][2] := IntToStr(StrToInt(listInvOlahan[idxBahan][2])-1);
							if(listInvOlahan[idxBahan][2] = '0') then
								delStrukDat(listInvOlahan,idxBahan);
						end;
					end;
					//tambahan hasil jual ke pemasukan dan total uang
					totPemasukan += StrToInt(daftarResep[i][1]);
					totUang += StrToInt(daftarResep[i][1]);
					totResepJual += 1;
					writeln('Jual resep berhasil');
				end else begin
					writeln('Bahan untuk membuat resep kurang');
				end;
			end else begin
				writeln('Resep tidak ditemukan');
			end;
		end else begin
			writeln('Energi tidak mencukupi');
		end;
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end.
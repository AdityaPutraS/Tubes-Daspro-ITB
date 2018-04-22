unit fitur;

interface
	uses tambahan, sysutils;
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran,energi,totUang : longint;tanggal : AnsiString;hariLewat : longint;var sudahTidur:boolean);
	procedure lihatInventori (listInvMentah, listInvOlahan: strukDat;var sudahTidur:boolean);// menampilkan data daftar bahan mentah dan bahan olahan yang tersedia di inventori saat ini terurut membesar menurut nama bahan
	procedure lihatResep (daftarResep: strukDat;var sudahTidur:boolean); //menampilkan data daftar resep yang tersedia beserta penyusunnya dengan terurut membesar
	procedure istirahat(var countIst:longint;var energi : longint;var sudahTidur:boolean);//menambah energi sebanyak 1 buah, maksimum istirahat 6 kali sehari, energi maksimum 10
	procedure makan (var countMakan, energi : longint;var sudahTidur:boolean); //menambah energi sebanyak 3 buah, maksimum makan 3 kali sehari, energi maksimum 10 
	procedure cariResep(daftarResep:strukDat;var sudahTidur:boolean);
	procedure tidur(tanggal:AnsiString;var hariLewat,energi:longint;daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;var sudahTidur:boolean;var countIst,countMakan:longint);
	procedure tambahresep (var daftarResep : strukDat;daftarBahMentah,daftarBahOlahan : strukDat;var sudahTidur:boolean);	
	procedure upgradeinventori (maksInv,totUang : longint;var sudahTidur:boolean);
	procedure lihatStatistik(status,listInvMentah,listInvOlahan:strukdat;var sudahTidur:boolean);
	procedure olahBahan(var energi, totBOlahanBuat:longint;maksInv:longint;daftarBahOlahan,daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;tanggal:ansiString;hariLewat : longint;var sudahTidur:boolean);
	procedure jualOlahan (var energi, totPemasukan,totBOlahanJual,totUang : longint; var listInvOlahan : strukDat; daftarBahOlahan : strukDat;var sudahTidur:boolean);
	procedure jualResep (var energi, totPemasukan,totResepJual,totUang : longint; var listInvOlahan, listInvMentah : strukDat; daftarResep : strukDat;var sudahTidur:boolean);
	procedure restock(hariLewat : longint; var daftarBahMentah : strukDat);
implementation
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran,energi,totUang : longint;tanggal : AnsiString;hariLewat : longint;var sudahTidur:boolean);
	//beli bahan sesuai spek soal.
	//I.S : daftarBahMentah dan variable lainnya terdefinisi, mungkin kosong
	//F.S : listInvMentah berisi bahan yang dibeli (jika berhasil beli)
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
							write('Total Bayar : ');writeln(kuantitas*harga);
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
									for j := 1 to hariLewat do begin
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
			writeln('Pembelian barang gagal karena energi tidak mencukupi.');
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure lihatInventori (listInvMentah, listInvOlahan: strukDat;var sudahTidur:boolean);
	//menampilkan inventori ke user
	//I.S : inventori terisi, mungkin kosong
	//F.S : di layar ada isi dari inventori
	var
		i,j:integer; //increment
	//Algoritma
	begin
		urut(listInvMentah);//mengurutkan invMentah
		urut(listInvOlahan);//mengurutkan invOlahan
		writeln('Inventori Bahan Mentah : ');
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
		writeln('Inventori Bahan Olahan : ');
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
	//menampilkan semua resep yang ada ke user
	//I.S : daftar resep terisi, mungkin kosong
	//F.S : di layar ada daftar resep yang ada
	var
		i,j:integer; //increment
	//Algoritma
	begin
		urut(daftarResep);// mengurutkan daftarResep
		writeln('Daftar Resep :');
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
	//istirahat, dan menambah 1 energi user, maks 6 kali istirahat dalam sehari
	//I.S : banyak istirahat disimpan di countIst, mungkin lebih dari 6
	//F.S : energi bertambah 1 jika sukses
	//algoritma 
	begin
		if (countIst<6) and (energi < 10) then
		begin
			energi += 1;
			countIst += 1;
			sudahTidur:=false;
			writeln('Istirahat berhasil, energi bertambah 1, energi sekarang sebanyak ',energi,'.');
		end else begin //countIst >= 6 atau energi > 10
			if (countIst = 6)then
			begin
				writeln('Istirahat gagal karena sudah istirahat 6 kali.');
			end else begin 
				writeln('Energi mencapai batas maksimum.');
			end;
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure makan (var countMakan, energi : longint;var sudahTidur:boolean);
	//makan, lalu menambah energi sebanyak 3, maks 3 kali makan dalam sehari
	//I.S : banyak makan dalam sehari disimpan di countMakan, mungkin lebih dari 3
	//F.S : energi bertambah 3 jika sukses;
	begin
		if (countMakan<3) and (energi + 3 <= 10) then
		begin
			energi:= energi + 3;
			countMakan:= countMakan +1;
			sudahTidur:=false;
			writeln('Makan berhasil, energi bertambah 3, energi sekarang sebanyak ',energi,'.');
		end else begin //countMakan > 3 atau energi > 7
			if (countMakan = 3 ) then
			begin
				writeln('Makan gagal karena sudah makan 3 kali.');
			end else begin
				energi :=10;
				writeln('Energi mencapai batas maksimum.');
			end;
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure cariResep(daftarResep:strukDat;var sudahTidur:boolean);
	//cari resep dari file daftarResep
	//I.S : daftarResep terdefinisi
	//F.S : ditampilkan di layar hasil pencarian, output tidak ketemu jika tidak ada
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
	procedure tidur(tanggal:AnsiString;var hariLewat,energi:longint;daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;var sudahTidur:boolean;var countIst,countMakan:longint);
	//tidur, lalu menghapus semua bahan kadaluarsa, serta merestock jika sudah waktunya, dan merubah energi menjadi 10
	//I.S : semua variable terdefinisi
	//F.S : bahan kadaluarsa hilang, stok di supermarket terisi lagi jika sudah 3 hari,energi menjadi 10
	var
		i,k,durasi,nEff:longint;
		temp,tanggalSekarang:ansiString;
	begin
		if(sudahTidur)then //validasi apakah sudah pernah tidur
		begin
			writeln('Tidur gagal karena Anda baru saja tidur.');
		end else begin
			tanggalSekarang := tanggal;
				for k := 1 to hariLewat do begin
					tambahHari(tanggalSekarang);
				end;
			//membuang semua bahan Olahan yang kadaluarsa
			i := 0; nEff := high(listInvOlahan);
			while(i <= nEff) do
			begin
				temp:=listInvOlahan[i][1]; //menyimpan tanggal buat olahan di temp
				for k:=1 to 3 do tambahHari(temp);
				if (temp=tanggalSekarang) then begin //membandingkan temp dengan tanggal sekarang
					delStrukDat(listInvOlahan,i);
					nEff -= 1;
				end else begin
					i +=1 ;
				end;
			end;
			//membuang semua bahan Mentah yang kadaluarsa
			i := 0;	nEff := high(listInvMentah);
			while(i <= nEff) do
			begin
				durasi := idxStrukDat(listInvMentah[i][0],daftarBahMentah,0); //durasi berisi indeksnya
				if(not(durasi = -1)) then begin
					//bahan ditemukan di daftarBahMentah
					durasi := StrToInt(daftarBahMentah[durasi][2]); //durasi berisi durasi dari bahan mentahnya
					temp := listInvMentah[i][1];
						for k := 1 to (durasi) do begin
							tambahHari(temp);
						end;
					if(temp = tanggalSekarang) then begin
						delStrukDat(listInvMentah,i);
						nEff -= 1;
					end else begin
						i += 1;
					end;
				end else begin
					writeln(listInvMentah[i][0],' merupakan item ilegal karena tidak ada di Daftar Bahan Mentah.');
					writeln('Item dihapus dari inventori');
					delStrukDat(listInvMentah,i);
					nEff -=1;
				end;
			end;
			//merestock daftar bahan mentah, pengecekan apakah sekarang harus di restock atau tidak dilakukan dalam prosedur restock
			restock(hariLewat,daftarBahMentah);
			//update variable
			hariLewat+=1;
			energi:=10;
			sudahTidur:=true;
			countIst:=0;
			countMakan:=0;
			//pesan kepada user
			writeln('Hari telah berganti.');
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure tambahresep (var daftarResep : strukDat;daftarBahMentah,daftarBahOlahan : strukDat;var sudahTidur:boolean);
	//menambah resep baru ke daftar resep
	//I.S : daftar resep terdefinisi
	//F.S : terdapat resep baru di daftar resep jika tambahResep sukses, output pesan kegagalan jika gagal
	var
		neff, i ,hargabeli,panjangtemp : longint; //menyimpan harga bahan mentah total untuk membuat resep
		namaResep : AnsiString;
	//ALGORITMA
	begin
		//Menambah panjang array dinamis
		SetLength(daftarResep, length(daftarResep)+1);
		SetLength(daftarResep[High(daftarResep)], 1);//untuk menampung nama resep pada input pertama
		neff := High(daftarResep); //neff berisi indeks tertinggi sekarang
		write('Masukkan Nama Resep : '); readln(namaResep);
		//validasi apabila nama sudah dimasukkan atau belum
		if isThere(namaResep, daftarResep)= True then //kondisi if bernilai true apabila ada nama bahan pada daftarResep
		begin
			repeat
				writeln('Nama resep telah dimasukkan sebelumnya. Ulangi!');
				write('Masukkan Nama Resep : ');
				readln(namaResep); // input ulang dari user
			until (not(isThere(namaResep, daftarResep)));
		end;
		daftarResep[neff][0] := namaResep;
		//input jumlah bahan dan bahan-bahannya
		write('Jumlah Bahan = ');
		readln(panjangtemp);
		if (panjangtemp<2) then
		//validasi, jumlah bahan harus >=2
			begin
				repeat
					writeln('Jumlah bahan harus >=2');
					write('Jumlah Bahan = ');
					readln(panjangtemp);
				until (panjangtemp>=2);
			end;
		SetLength(daftarResep[neff], length(daftarResep[neff])+panjangtemp+2);
		daftarResep[neff][2]:=inttostr(panjangtemp); //input jumlah bahan
		hargabeli:=0; // akan digunakan untuk menyimpan penjumlahan dari semua harga barang mentah
		writeln('Masukkan Bahan-Bahan :');
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
		writeln('Total harga bahan-bahan : ',hargabeli);
		write('Harga Jual : ');
		readln(daftarResep[neff][1]); //input harga jual
		//validasi apakah harga jual lebih dari 12.5 persen dari harga beli
		if (StrToInt(daftarResep[neff][1]) <= 1.25*hargabeli) then
		begin
			repeat
				writeln ('Harga jual harus minimal 12.5% lebih daripada total harga bahan-bahan! ');
				write('Harga Jual : ');
				readln(daftarResep[neff][1]); //input harga jual
			until (StrToInt(daftarResep[neff][1]) >= 1.25*hargabeli);
		end;
		writeln('Resep berhasil dimasukkan.');
		sudahTidur:=false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure upgradeinventori (maksInv,totUang : longint;var sudahTidur:boolean);
	//menambah inventori sebanyak 25
	//I.S : totUang terdefiisi, mungkin tidak cukup
	//F.S : maksimal inventori bertambah 25 jika sukses
	const
		hargainventori = 100000;//harga yang dibutuhkan untuk upgrade inventori
	begin
		if (hargainventori < totUang) then
		begin
			totUang := totUang - hargainventori;
			maksInv := maksInv + 25; //penambahan 25 terhadap maksimal inventori ketika prosedur ini dijalankan
			writeln('Transaksi berhasil, kapasitas inventori bertambah, kapasitas sekarang : ',maksInv,'.');
		end else
			writeln ('Transaksi gagal, uang tidak cukup');
		sudahTidur:=false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure lihatStatistik(status,listInvMentah,listInvOlahan:strukdat;var sudahTidur:boolean);
	//menampilkan semua statistik ke layar, serta barang apa saja yang ada di inventori
	//I.S : semua variable terdefinisi
	//F.S : di layar user akan tampil data data tentang simulasi
	var
		temp:ansiString;
		i:integer;
	begin
		//memunculkan data dari status pengguna
		//jangan diubah banyak tab nya
		writeln('Nomor Simulasi		: ',status[0][0]);
		writeln('Tanggal Simulasi	: ',status[0][1]);
		temp:= status[0][1];
		for i:=1 to strtoint(status[0][2]) do tambahHari(temp);
		writeln('Tanggal Hari Ini	: ',temp);
		writeln('Jumlah Hari Hidup	: ',status[0][2]);
		writeln('Jumlah Energi		: ',status[0][3]);
		writeln('Maksimum Inventori	: ',status[0][4]);
		writeln('Bahan Mentah Dibeli	: ',status[0][5]);
		writeln('Bahan Olahan Dibuat	: ',status[0][6]);
		writeln('Bahan Olahan Dijual	: ',status[0][7]);
		writeln('Resep Dijual		: ',status[0][8]);
		writeln('Total Pemasukan		: ',status[0][9]);
		writeln('Total Pengeluaran	: ',status[0][10]);
		writeln('Total Uang		: ',status[0][11]);
		writeln('/////////////////////////////////////////');
		//memunculkan inventori
		lihatInventori(listInvMentah, listInvOlahan,sudahTidur);
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure olahBahan(var energi, totBOlahanBuat:longint;maksInv:longint;daftarBahOlahan,daftarBahMentah:strukDat;var listInvMentah,listInvOlahan:strukDat;tanggal:ansiString;hariLewat : longint;var sudahTidur:boolean);
	//mengolah bahan mentah menjadi bahan olahan
	//I.S : semua variable terdefinisi, bahan baku mungkin tidak cukup
	//F.S : menambah bahan yang telah di olah ke inventori olahan
	var
		i,j,k,idxBahan:integer;
		namaOlah, tanggalSekarang:AnsiString;
		statusCari : AnsiString;
	begin
		if(energi>0) then//pengecekan apakah ada energi 
		begin 
			write('Masukkan Nama Olahan : ');
			readln(namaOlah);
			//normalisasi
			namaOlah := LowerCase(namaOlah);
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
						//menghitung tanggal sekarang
								tanggalSekarang := tanggal;
								for k := 1 to hariLewat do begin
									tambahHari(tanggalSekarang);
								end;
						//masukan ke invBahanOlahan
							//cek apakah sudah ada 
							j := 0;
							statusCari := 'tidak ada';
							while( (j <= high(listInvOlahan)) and (not(statusCari = 'ketemu, tanggal sama'))) do begin
								if(LowerCase(listInvOlahan[j][0]) = namaOlah) then begin
									//ketemu, asumsi tanggalnya beda
									statusCari := 'ketemu, tanggal beda';
									//cek tanggal nya sekarang
									if(listInvOlahan[j][1] = tanggalSekarang) then begin
										statusCari := 'ketemu, tanggal sama';
									end else begin
										j += 1;
									end;
								end else begin
									j += 1;
								end;
							end;
							//masukkan berdasarkan statusnya
							if( (statusCari = 'tidak ada') or (statusCari = 'ketemu, tanggal beda') ) then begin
								//tambah baru di paling bawah
								setLength(listInvOlahan, length(listInvOlahan)+1);
								setLength(listInvOlahan[high(listInvOlahan)], 3);
								listInvOlahan[high(listInvOlahan)][0] := daftarBahOlahan[i][0];
								listInvOlahan[high(listInvOlahan)][1] := tanggalSekarang;
								listInvOlahan[high(listInvOlahan)][2] := '1';
							end else begin
								//ada yang tanggalnya sama, tinggal tambah jumlahnya
								listInvOlahan[j][2] := IntToStr(StrToInt(listInvOlahan[j][2])+1);
							end;
						totBOlahanBuat += 1;
						writeln('Olah bahan sukses.');
					end else begin
						writeln('Inventori tidak muat.');
					end;
				end else begin
					writeln('Bahan mentah kurang.');
				end;
			end else begin
				writeln('Nama bahan olahan tidak ditemukan.');
			end;
		end	else begin
			writeln('Energi tidak mencukupi.');//memunculkan pesan kelsalahan jika energi tidak mencukupi 
		end;
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure jualOlahan (var energi, totPemasukan,totBOlahanJual,totUang : longint; var listInvOlahan : strukDat; daftarBahOlahan : strukDat;var sudahTidur:boolean);
	//menjual bahan olahan
	//I.S : nama bahan mungkin tidak ada di daftarBahan, serta mungkin tidak ada di inventori
	//F.S : uang bertambah jika jualOlahan sukses
	var
		i,j : longint;
		namaOlah : AnsiString;
	begin
		if(energi > 0) then begin
			write('Masukan Nama Bahan Olahan : ');
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
					writeln('Sukses menjual bahan olahan.');
				end else begin
					//jaga jaga aja
					writeln('Tidak bisa menemukan bahan olahan di daftar bahan olahan untuk dicari harganya.');
				end;
			end else begin
				writeln('Bahan olahan tidak ditemukan di inventori.');
			end;
		end else begin
			writeln('Energi tidak mencukupi.');
		end;
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure jualResep (var energi, totPemasukan,totResepJual,totUang : longint; var listInvOlahan, listInvMentah : strukDat; daftarResep : strukDat;var sudahTidur:boolean);
	//mengolah bahan olahan sesuai resep, lalu menjualnya
	//I.S : semua variable terdefinisi, resep mungkin tidak ada, bahan mungkin kurang
	//F.S : uang bertambah jika penjualan sukses
	var
		i,j, idxBahan : longint;
		namaResep : AnsiString;
	begin
		if(energi > 0) then begin
			write('Masukan Nama Resep : ');
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
					writeln('Jual resep berhasil.');
				end else begin
					writeln('Bahan untuk membuat resep kurang.');
				end;
			end else begin
				writeln('Resep tidak ditemukan.');
			end;
		end else begin
			writeln('Energi tidak mencukupi.');
		end;
		sudahTidur := false;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure restock(hariLewat : longint; var daftarBahMentah : strukDat);
	//merestock semua bahan mentah sebanyak 5 di supermarket dengan periode 3 hari sekali
	//I.S : daftarBahMentah terdefinisi
	//F.S : semua bahan mentah bertambah isinya sebanyak 5 jika sudah 3 hari
	var
		i : longint;
	begin
		//cek apakah sudah 3 hari
		if(hariLewat mod 3 = 0) then begin
			for i := 0 to high(daftarBahMentah) do begin
				daftarBahMentah[i][3] := IntToStr(StrToInt(daftarBahMentah[i][3])+5);
			end;
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end.
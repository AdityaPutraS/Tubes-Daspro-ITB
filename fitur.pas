unit fitur;

interface
	type
		strukDat = array of array of AnsiString;
	procedure loadFileToArr(namaFile : AnsiString; var dat : strukDat); //meload file dengan nama (namaFile) ke variable dat
	procedure overWriteArrToFile(namaFile : AnsiString;dat : strukDat); //overwrite isi file dengan isi baru yaitu array dat
	procedure load(var daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat);//meload semua data yang diperlukan
	procedure loadStatus(status : strukDat;var nomorSim : longint;var tanggal : AnsiString;var hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
	procedure save(daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat); //save semua data ke file nya masing masing
	procedure saveStatus(var status : strukDat;nomorSim : longInt;tanggal : AnsiString;hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran : longint;tanggal : AnsiString);
implementation
	uses tambahan, sysutils;
	procedure loadFileToArr(namaFile : AnsiString; var dat : strukDat);
	//meload file bernama "namafile" lalu menyimpannya di variable dat
	var
		tempFile : TextFile;
		s : AnsiString;
		i : integer;
	begin
		i := 1; //iterator
		Assign(tempFile, namaFile); //buka file
		reset(tempFile);
		//mulai load file ke array
		while not eof(tempFile) do
		begin
			SetLength(dat,i);
			readln(tempFile, s);
			dat[i-1] := parseString(s);
			i += 1;
		end;
		Close(tempFile);
	end;
	procedure overWriteArrToFile(namaFile : AnsiString; dat : strukDat);
	//mengisi file dengan isi array, overwrite karena isi dari file dihapus dulu, baru diisi
	var
		tempFile : TextFile;
		i,j : longint;
	begin
		Assign(tempFile, namaFile);
		rewrite(tempFile);
		//mulai masukan ke file
		for i := 0 to High(dat) do begin
			for j := 0 to High(dat[i])-1 do begin
				write(tempFile, dat[i][j]);
				write(tempFile, ' | ');
			end;
			writeln(tempFile, dat[i][High(dat[i])]);
		end;
		Close(tempFile);
	end;
	procedure load(var daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat);
	//meload semua file yang dibutuhkan, lalu disimpan ke array masing masing
	begin
		loadFileToArr('daftarBahanMentah.txt', daftarBahMentah);
		loadFileToArr('listInventoriMentah.txt', listInvMentah);
		loadFileToArr('daftarBahanOlahan.txt', daftarBahOlahan);
		loadFileToArr('listInventoriOlahan.txt', listInvOlahan);
		loadFileToArr('daftarResep.txt', daftarResep);
		loadFileToArr('statusPengguna.txt',status);
	end;
	procedure loadStatus(status : strukDat;var nomorSim : longint;var tanggal : AnsiString;var hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
	//meload semua variable status seperti tanggal, maksInventori, energi awal, dll
	begin
	//urutannya ngikutin yang di file eksternal statusPengguna.txt
		val(status[0][0],nomorSim);
		tanggal := status[0][1];
		val(status[0][2], hariLewat);
		val(status[0][3], energi);
		val(status[0][4], maksInv);
		val(status[0][5], totBMentahBeli);
		val(status[0][6], totBOlahanBuat);
		val(status[0][7], totBOlahanJual);
		val(status[0][8], totResepJual);
		val(status[0][9], totPemasukan);
		val(status[0][10], totPengeluaran);
		val(status[0][11], totUang);
	end;
	procedure save(daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat);
	//menyimpan semua isi array ke file eksternal nya masing masing
	begin
		overWriteArrToFile('daftarBahanMentah.txt', daftarBahMentah);
		overWriteArrToFile('listInventoriMentah.txt', listInvMentah);
		overWriteArrToFile('daftarBahanOlahan.txt', daftarBahOlahan);
		overWriteArrToFile('listInventoriOlahan.txt', listInvOlahan);
		overWriteArrToFile('daftarResep.txt', daftarResep);
		overWriteArrToFile('statusPengguna.txt',status);
	end;
	procedure saveStatus(var status : strukDat;nomorSim : longInt;tanggal : AnsiString;hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
	//menyimpan semua variable status ke array status
	begin
		str(nomorSim, status[0][0]);
		status[0][1] := tanggal;
		str(hariLewat, status[0][2]);
		str(energi, status[0][3]);
		str(maksInv, status[0][4]);
		str(totBMentahBeli, status[0][5]);
		str(totBOlahanBuat, status[0][6]);
		str(totBOlahanJual, status[0][7]);
		str(totResepJual, status[0][8]);
		str(totPemasukan, status[0][9]);
		str(totPengeluaran, status[0][10]);
		str(totUang, status[0][11]);
	end;
	procedure beliBahan(var daftarBahMentah,listInvMentah :strukDat;listInvOlahan : strukDat;maksInv : longint;var totBMentahBeli,totPengeluaran : longint;tanggal : AnsiString);
	//beli bahan sesuai spek soal.
	var
		namaB : AnsiString;
		i,j,indeksInv : longint;
		kuantitas,total,harga,stok : longint;
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
	end;
end.
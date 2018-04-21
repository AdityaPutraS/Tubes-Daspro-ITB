unit sistem;
interface
	uses tambahan,sysutils;
	procedure loadFileToArr(namaFile : AnsiString; var dat : strukDat); //meload file dengan nama (namaFile) ke variable dat
	procedure overWriteArrToFile(namaFile : AnsiString;dat : strukDat); //overwrite isi file dengan isi baru yaitu array dat
	procedure load(var sav : strukDatSave);
	procedure save(sav : strukDatSave);
	procedure loadToVar(nomor  : longint;sav : strukDatSave;var daftarBahMentah,listInvMentah,daftarBahOlahan,listInvOlahan,daftarResep,status : strukDat); 
	procedure saveFromVar(nomor : longint;var sav : strukDatSave; daftarBahMentah,listInvMentah,daftarBahOlahan,listInvOlahan,daftarResep,status : strukDat); 
	procedure loadStatus(status : strukDat;var nomorSim : longint;var tanggal : AnsiString;var hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
	procedure saveStatus(var status : strukDat;nomorSim : longInt;tanggal : AnsiString;hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
implementation
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure loadFileToArr(namaFile : AnsiString; var dat : strukDat);
	//meload file bernama "namafile" lalu menyimpannya di variable dat
	//I.S : namaFile terdeifinisi, dat kosong
	//F.S : dat berisi data dari file eksternal namaFile.txt
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure overWriteArrToFile(namaFile : AnsiString; dat : strukDat);
	//mengisi file dengan isi array, overwrite karena isi dari file dihapus dulu, baru diisi
	//I.S : namaFile terdefinisi, dat terdefinisi
	//F.s : namaFile.txt berisi data dari dat
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure load(var sav : strukDatSave);
	//meload semua file yang dibutuhkan, lalu disimpan ke array masing masing
	//I.S : daftarBahMentah,listInvMentah,daftarBahOlahan,listInvOlahan,daftarResep,status kosong
	//F.S : semua strukDat tersebut terisi oleh data dari file eksternalnya masing masing
	var
		i : longint;
		daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat;
		nomor : AnsiString;
		temp : saveGame;
	begin
		setLength(sav,banyakSimulasi);
		for i := 1 to banyakSimulasi do begin
			nomor := IntToStr(i);
			loadFileToArr('save/'+nomor+'/daftarBahanMentah.txt', daftarBahMentah);
			loadFileToArr('save/'+nomor+'/listInventoriMentah.txt', listInvMentah);
			loadFileToArr('save/'+nomor+'/daftarBahanOlahan.txt', daftarBahOlahan);
			loadFileToArr('save/'+nomor+'/listInventoriOlahan.txt', listInvOlahan);
			loadFileToArr('save/'+nomor+'/daftarResep.txt', daftarResep);
			loadFileToArr('save/'+nomor+'/statusPengguna.txt',status);
			temp.daftarBahMentah := daftarBahMentah;
			temp.listInvMentah := listInvMentah;
			temp.daftarBahOlahan := daftarBahOlahan;
			temp.listInvOlahan := listInvOlahan;
			temp.daftarResep := daftarResep;
			temp.status := status;
			loadStatus(temp.status, temp.nomorSim,temp.tanggal,temp.hariLewat,temp.energi,temp.maksInv,temp.totBMentahBeli,temp.totBOlahanBuat,temp.totBOlahanJual,temp.totResepJual,temp.totPemasukan,temp.totPengeluaran,temp.totUang);
			sav[i-1] := temp;
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure save(sav : strukDatSave);
	//menyimpan semua file yang ada ke file eksternalnya masing masing
	//I.S : sav mungkin kosong, file eksternal sudah ada
	//F.S : file eksternal berisi data dari sav
	var
		i : longint;
		nomor : AnsiString;
		temp : saveGame;
	begin
		for i := 1 to banyakSimulasi do begin
		temp := sav[i-1]; //i-1 karena mulai dari 0
		//menyimpan semua strukDat ke txt nya masing masing
		nomor := IntToStr(i);
		//saveStatus(temp.status,temp.nomorSim,temp.tanggal,temp.hariLewat,temp.energi,temp.maksInv,temp.totBMentahBeli,temp.totBOlahanBuat,temp.totBOlahanJual,temp.totResepJual,temp.totPemasukan,temp.totPengeluaran,temp.totUang);
		overWriteArrToFile('save/'+nomor+'/daftarBahanMentah.txt', temp.daftarBahMentah);
		overWriteArrToFile('save/'+nomor+'/listInventoriMentah.txt', temp.listInvMentah);
		overWriteArrToFile('save/'+nomor+'/daftarBahanOlahan.txt', temp.daftarBahOlahan);
		overWriteArrToFile('save/'+nomor+'/listInventoriOlahan.txt', temp.listInvOlahan);
		overWriteArrToFile('save/'+nomor+'/daftarResep.txt',temp.daftarResep);
		overWriteArrToFile('save/'+nomor+'/statusPengguna.txt',temp.status);
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure loadToVar(nomor  : longint;sav : strukDatSave;var daftarBahMentah,listInvMentah,daftarBahOlahan,listInvOlahan,daftarResep,status : strukDat); 
	begin
		daftarBahMentah := sav[nomor-1].daftarBahMentah;
		listInvMentah := sav[nomor-1].listInvMentah;
		daftarBahOlahan := sav[nomor-1].daftarBahOlahan;
		listInvOlahan := sav[nomor-1].listInvOlahan;
		daftarResep := sav[nomor-1].daftarResep;
		status := sav[nomor-1].status;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure saveFromVar(nomor : longint;var sav : strukDatSave; daftarBahMentah,listInvMentah,daftarBahOlahan,listInvOlahan,daftarResep,status : strukDat); 
	begin
		sav[nomor-1].daftarBahMentah := daftarBahMentah;
		sav[nomor-1].listInvMentah := listInvMentah;
		sav[nomor-1].daftarBahOlahan := daftarBahOlahan;
		sav[nomor-1].listInvOlahan := listInvOlahan;
		sav[nomor-1].daftarResep := daftarResep;
		sav[nomor-1].status := status;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure loadStatus(status : strukDat;var nomorSim : longint;var tanggal : AnsiString;var hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
	//meload semua variable status seperti tanggal, maksInventori, energi awal, dll
	//I.S : status terdefinisi, semua paramater seperti nomorSim, tanggal, harilewat, dll kosong
	//F.S : semua parameter terdefinisi sesuai isi dari strukDat status terdeifinisi
	begin
	//urutannya mengikuti yang di file eksternal statusPengguna.txt
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure saveStatus(var status : strukDat;nomorSim : longInt;tanggal : AnsiString;hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint);
	//menyimpan semua variable status ke array status
	//I.S : semua parameter terdefinisi
	//F.S : strukDat status terisi data baru dari parameter
	begin
	//TODO :
	//	- Tambahin error code
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end.
unit sistem;
//berisi fungsi untuk load dan save
interface
uses tambahan,sysutils;
	procedure loadDaftarBahanMentah(var dafBMentah : daftarBMentah);
	procedure saveDaftarBahanMentah(dafBMentah : daftarBMentah);
	procedure loadDaftarBahanOlahan(var dafBOlah : daftarBOlahan);
	procedure saveDaftarBahanOlahan(dafBOlah : daftarBOlahan);
	procedure loadInventoriBahanMentah(var invBMentah : listBMentah);
	procedure saveInventoriBahanMentah(invBMentah : listBMentah);
	procedure loadInventoriBahanOlahan(var invBOlah : listBOlahan);
	procedure saveInventoriBahanOlahan(invBOlah : listBOlahan);
	procedure loadDaftarResep(var dafRes : daftarResep);
	procedure saveDaftarResep(dafRes : daftarResep);
	procedure loadStatus(var status : statusPengguna);
	procedure saveStatus(status : statusPengguna);
	procedure load(var dafBMentah : daftarBMentah;var dafBOlah : daftarBOlahan;var invBMentah : listBMentah;var invBOlah : listBOlahan;var dafRes : daftarResep;var status : statusPengguna);
	procedure save(dafBMentah : daftarBMentah;dafBOlah : daftarBOlahan;invBMentah : listBMentah;invBOlah : listBOlahan;dafRes : daftarResep;status : statusPengguna);
implementation
	procedure loadDaftarBahanMentah(var dafBMentah : daftarBMentah);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
		bMentah		: bahanMentah;
	begin
		dafBMentah.nEff := 0;
		Assign(tempFile, 'Data/daftarBahanMentah.txt'); //buka file
		reset(tempFile);
		//mulai load file ke array
		while not eof(tempFile) do
		begin
			//TODO : Cek apakah nEff < NMax
			readln(tempFile,s);
			tempArr := parseString(s);
			bMentah.nama := tempArr.data[1];
			bMentah.harga := StrToInt(tempArr.data[2]);
			bMentah.durasi := StrToInt(tempArr.data[3]);
			dafBMentah.nEff += 1;
			dafBMentah.data[dafBMentah.nEff] := bMentah;
		end;
		Close(tempFile);
	end;
	procedure saveDaftarBahanMentah(dafBMentah : daftarBMentah);
	var
		tempFile	: textFile;
		s			: AnsiString;
		i			: longint;
		bMentah		: bahanMentah;	
	begin
		Assign(tempFile, 'Data/daftarBahanMentah.txt');
		rewrite(tempFile);
		for i := 1 to dafBMentah.NEff do begin
			bMentah := dafBMentah.data[i];
			s := bMentah.nama + ' | ' + IntToStr(bMentah.harga) + ' | ' + IntToStr(bMentah.durasi);
			writeln(tempFile, s);
		end;
		Close(tempFile);
	end;
	procedure loadDaftarBahanOlahan(var dafBOlah : daftarBOlahan);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
		banyak,i		: longint;
		bOlah		: bahanOlahan;
	begin
		dafBOlah.nEff := 0;
		Assign(tempFile, 'Data/daftarBahanOlahan.txt'); //buka file
		reset(tempFile);
		//mulai load file ke array
		while not eof(tempFile) do
		begin
			//TODO : Cek apakah nEff < NMax
			readln(tempFile,s);
			tempArr := parseString(s);
			bOlah.nama := tempArr.data[1];
			bOlah.harga := StrToInt(tempArr.data[2]);
			banyak := StrToInt(tempArr.data[3]);
			bOlah.nEff := 0;
			for i := 1 to banyak do begin
				bOlah.nEff += 1;
				bOlah.listBahan[bOlah.nEff] := tempArr.data[3+i];
			end;
			dafBOlah.nEff += 1;
			dafBOlah.data[dafBOlah.nEff] := bOlah;
		end;
		Close(tempFile);
	end;
	procedure saveDaftarBahanOlahan(dafBOlah : daftarBOlahan);
	var
		tempFile	: textFile;
		s			: AnsiString;
		i,j			: longint;
		bOlah	: bahanOlahan;	
	begin
		Assign(tempFile, 'Data/daftarBahanMentah.txt');
		rewrite(tempFile);
		for i := 1 to dafBOlah.NEff do begin
			bOlah := dafBOlah.data[i];
			s := bOlah.nama + ' | ' + IntToStr(bOlah.harga) + ' | ' + IntToStr(bOlah.nEff);
			for j := 1 to bOlah.nEff do begin
				s := s + ' | ' + bOlah.listBahan[j];
			end;
			writeln(tempFile, s);
		end;
		Close(tempFile);
	end;
	procedure loadInventoriBahanMentah(var invBMentah : listBMentah);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
	begin
		invBMentah.nEff := 0;
		Assign(tempFile, 'Data/listInventoriMentah.txt'); //buka file
		reset(tempFile);
		//mulai load file ke array
		while not eof(tempFile) do
		begin
			//TODO : Cek apakah nEff < NMax
			readln(tempFile,s);
			tempArr := parseString(s);
			invBMentah.nEff += 1;
			invBMentah.nama[invBMentah.nEff] := tempArr.data[1];
			invBMentah.tanggal[invBMentah.nEff] := tempArr.data[2];
			invBMentah.jumlah[invBMentah.nEff] := tempArr.data[3];
		end;
		Close(tempFile);
	end;
	procedure saveInventoriBahanMentah(invBMentah : listBMentah);
	var
		tempFile	: textFile;
		i			: longint;
		s			: AnsiString;
	begin
		Assign(tempFile, 'Data/listInventoriMentah.txt');
		rewrite(tempFile);
		for i := 1 to invBMentah.nEff do begin
			s := invBMentah.nama[i] + ' | ' + invBMentah.tanggal[i] + ' | ' + invBMentah.jumlah[i];
			writeln(tempFile,s);
		end;
		Close(tempFile);
	end;
	procedure loadInventoriBahanOlahan(var invBOlah : listBOlahan);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
	begin
		invBOlah.nEff := 0;
		Assign(tempFile, 'Data/listInventoriOlahan.txt'); //buka file
		reset(tempFile);
		//mulai load file ke array
		while not eof(tempFile) do
		begin
			//TODO : Cek apakah nEff < NMax
			readln(tempFile,s);
			tempArr := parseString(s);
			invBOlah.nEff += 1;
			invBOlah.nama[invBOlah.nEff] := tempArr.data[1];
			invBOlah.tanggal[invBOlah.nEff] := tempArr.data[2];
			invBOlah.jumlah[invBOlah.nEff] := tempArr.data[3];
		end;
		Close(tempFile);
	end;
	procedure saveInventoriBahanOlahan(invBOlah : listBOlahan);
	var
		tempFile	: textFile;
		i			: longint;
		s			: AnsiString;
	begin
		Assign(tempFile, 'Data/listInventoriOlahan.txt');
		rewrite(tempFile);
		for i := 1 to invBOlah.nEff do begin
			s := invBOlah.nama[i] + ' | ' + invBOlah.tanggal[i] + ' | ' + invBOlah.jumlah[i];
			writeln(tempFile,s);
		end;
		Close(tempFile);
	end;
	procedure loadDaftarResep(var dafRes : daftarResep);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
		res			: resep;
		banyak, i	: longint;
	begin
		dafRes.nEff := 0;
		Assign(tempFile, 'Data/daftarResep.txt'); //buka file
		reset(tempFile);
		//mulai load file ke array
		while not eof(tempFile) do
		begin
			//TODO : Cek apakah nEff < NMax
			readln(tempFile,s);
			tempArr := parseString(s);
			res.nama := tempArr.data[1];
			res.harga := StrToInt(tempArr.data[2]);
			banyak := StrToInt(tempArr.data[3]);
			res.nEff := 0;
			for i := 1 to banyak do begin
				res.nEff += 1;
				res.listBahan[res.nEff] := tempArr.data[3+i];
			end;
			dafRes.nEff += 1;
			dafRes.data[dafRes.nEff] := res;
		end;
		Close(tempFile);
	end;
	procedure saveDaftarResep(dafRes : daftarResep);
	var
		tempFile	: textFile;
		i,j			: longint;
		res			: resep;
		s			: AnsiString;
	begin
		Assign(tempFile, 'Data/daftarResep.txt');
		rewrite(tempFile);
		for i := 1 to dafRes.nEff do begin
			res := dafRes.data[i];
			s := res.nama + ' | ' + IntToStr(res.harga) + ' | ' + IntToStr(res.nEff);
			for j := 1 to res.nEff do begin
				s := s + ' | ' + res.listBahan[j];
			end;
			writeln(tempFile,s);
		end;
		Close(tempFile);
	end;
	procedure loadStatus(var status : statusPengguna);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
	begin
		Assign(tempFile, 'Data/statusPengguna.txt'); //buka file
		reset(tempFile);
		//mulai load file ke array
		while not eof(tempFile) do
		begin
			readln(tempFile,s);
			tempArr := parseString(s);
			status.nomor := StrToInt(tempArr.data[1]);
			status.tanggal := tempArr.data[2];
			status.jumHari := StrToInt(tempArr.data[3]);
			status.jumEnergi := StrToInt(tempArr.data[4]);
			status.maksInv := StrToInt(tempArr.data[5]);
			status.totBMentahBeli := StrToInt(tempArr.data[6]);
			status.totBOlahBuat := StrToInt(tempArr.data[7]);
			status.totBOlahJual := StrToInt(tempArr.data[8]);
			status.totResepJual := StrToInt(tempArr.data[9]);
			status.totPemasukan := StrToInt(tempArr.data[10]);
			status.totPengeluaran := StrToInt(tempArr.data[11]);
			status.totPendapatan := StrToInt(tempArr.data[12]);
		end;
	end;
	procedure saveStatus(status : statusPengguna);
	var
		tempFile	: textFile;
		s			: AnsiString;
	begin
		Assign(tempFile, 'Data/statusPengguna.txt');
		rewrite(tempFile);
		s := IntToStr(status.nomor) + ' | ' + status.tanggal + ' | ' + IntToStr(status.jumHari) + ' | ' + IntToStr(status.jumEnergi) + ' | ' + IntToStr(status.maksInv);
		s := s + ' | ' + IntToStr(status.totBMentahBeli) + ' | ' + IntToStr(status.totBOlahBuat) + ' | ' + IntToStr(status.totBOlahJual) + ' | ' + IntToStr(status.totResepJual) + ' | ' + IntToStr(status.totPemasukan) + ' | ' + IntToStr(status.totPengeluaran) + ' | ' + IntToStr(status.totPendapatan); 
		writeln(tempFile,s);
		Close(tempFile);
	end;
	procedure load(var dafBMentah : daftarBMentah;var dafBOlah : daftarBOlahan;var invBMentah : listBMentah;var invBOlah : listBOlahan;var dafRes : daftarResep;var status : statusPengguna);
	begin
		loadDaftarBahanMentah(dafBMentah);
		loadDaftarBahanOlahan(dafBOlah);
		loadInventoriBahanMentah(invBMentah);
		loadInventoriBahanOlahan(invBOlah);
		loadDaftarResep(dafRes);
		loadStatus(status);
		writeln('> Sukses membaca semua data dari File Eksternal');
	end;
	procedure save(dafBMentah : daftarBMentah;dafBOlah : daftarBOlahan;invBMentah : listBMentah;invBOlah : listBOlahan;dafRes : daftarResep;status : statusPengguna);
	begin
		saveDaftarBahanMentah(dafBMentah);
		saveDaftarBahanOlahan(dafBOlah);
		saveInventoriBahanMentah(invBMentah);
		saveInventoriBahanOlahan(invBOlah);
		saveDaftarResep(dafRes);
		saveStatus(status);
		writeln('> Sukses menyimpan semua data ke File Eksternal');
	end;
end.
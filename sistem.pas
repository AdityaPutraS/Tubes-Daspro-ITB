unit sistem;
//berisi fungsi untuk load dan save
interface
const
	NMax = 100;
type
	bahanMentah = record
		nama	: AnsiString;
		harga	: longint;
		durasi	: longint;
	end;
	bahanOlahan = record
		nama	: AnsiString;
		harga	: longint;
		listBahan	: array[1..NMax] of AnsiString;
		nEff 	: longint;
	end;
	resep = record
		nama	: AnsiString;
		harga	: longint;
		listBahan	: array[1..NMax] of AnsiString;
		nEff	: longint;
	end;
	daftarBMentah = record
		data : array[1..NMax] of bahanMentah;
		nEff : longint;
	end;
	daftarBOlahan = record
		data : array[1..NMax] of bahanOlahan;
		nEff : longint;
	end;
	listBMentah = record
		nama : array[1..NMax] of AnsiString;
		tanggal : array[1..NMax] of AnsiString;
		jumlah : array[1..NMax] of AnsiString;
		nEff : longint;
	end;
	listBOlahan = record
		nama : array[1..NMax] of AnsiString;
		tanggal : array[1..NMax] of AnsiString;
		jumlah : array[1..NMax] of AnsiString;
		nEff : longint;
	end;
	daftarResep = record
		data : array[1..NMax] of resep;
		nEff : longint;
	end;
	statusPengguna = record
		nomor	: longint;
		tanggal	: AnsiString;
		jumHari	: longint;
		jumEnergi : longint;
		maksInv : longint;
		totBMentahBeli	: longint;		
		totBOlahBuat	: longint;
		totBOlahJual	: longint;
		totResepJual	: longint;
		totPemasukan	: longint;
		totPengeluaran	: longint;
		totPendapatan	: longint;
	end;
	procedure loadDaftarBahanMentah(var dafBMentah : daftarBMentah);
	procedure loadDaftarBahanOlahan(var dafBOlah : daftarBOlahan);
	procedure loadInventoriBahanMentah(var invBMentah : listBMentah);
	procedure loadInventoriBahanOlahan(var invBOlah : listBOlahan);
implementation
	uses tambahan,sysutils;
	procedure loadDaftarBahanMentah(var dafBMentah : daftarBMentah);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
		bMentah		: bahanMentah;
	begin
		dafBMentah.nEff := 0;
		Assign(tempFile, 'daftarBahanMentah.txt'); //buka file
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
	procedure loadDaftarBahanOlahan(var dafBOlah : daftarBOlahan);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
		banyak,i		: longint;
		bOlah		: bahanOlahan;
	begin
		dafBOlah.nEff := 0;
		Assign(tempFile, 'daftarBahanOlahan.txt'); //buka file
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
	procedure loadInventoriBahanMentah(var invBMentah : listBMentah);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
	begin
		invBMentah.nEff := 0;
		Assign(tempFile, 'listInventoriMentah.txt'); //buka file
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
	procedure loadInventoriBahanOlahan(var invBOlah : listBOlahan);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
	begin
		invBOlah.nEff := 0;
		Assign(tempFile, 'listInventoriOlahan.txt'); //buka file
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
	procedure loadDaftarResep(var dafRes : daftarResep);
	var
		tempFile	: textFile;
		s 			: AnsiString;
		tempArr		: miniArr;
		res			: resep;
		banyak, i	: longint;
	begin
		dafRes.nEff := 0;
		Assign(tempFile, 'daftarResep.txt'); //buka file
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
	procedure
		
end.
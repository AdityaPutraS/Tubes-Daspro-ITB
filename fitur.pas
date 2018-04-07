unit fitur;

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
	listMentah = record
		data : array[1..NMax] of bahanMentah;
		nEff : longint;
	end;
	listOlahan = record
		data : array[1..NMax] of bahanOlahan;
		nEff : longint;
	end;
	listResep = record
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
	procedure loadDaftarBahanMentah(var dafBMentah : listMentah);
	procedure loadDaftarBahanOlahan(var dafBOlah : listOlahan);
implementation
	uses tambahan,sysutils;
	procedure loadDaftarBahanMentah(var dafBMentah : listMentah);
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
	procedure loadDaftarBahanOlahan(var dafBOlah : listOlahan);
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
end.
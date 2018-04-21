unit tambahan;

interface
	uses sysutils,math;
	const
		hargainventori = 100000;//harga yang dibutuhkan untuk upgrade inventori
		banyakSimulasi = 3;
	type
		miniArr = array of AnsiString;
		strukDat = array of array of AnsiString;
		penanggalan = record
		h,b,t:integer;
		end;
		saveGame = record
		nomorSim, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint;
		daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat;
		tanggal : AnsiString;
		end;
		strukDatSave = array of saveGame;
	function parseString(s : AnsiString):miniArr;
	procedure delStrukDat(var arr : strukDat; pos : longint);
	procedure tambahHari(var tanggal:ansistring);
	function isKabisat(tahun:integer):boolean;
	procedure ambilHari(tanggal:ansistring;var sekarang:penanggalan);
	procedure urut(var list: strukDat);//mengurutkan data pada array
	function isThere(x : string ; T : strukDat) : Boolean;
	function idxStrukDat(x : string; dat : strukDat;kolom : longint) : longint;
	function hargaBahan (x : string ;T : strukDat) : longint;
	function sugesti(s : AnsiString) : AnsiString;
	//function sugestiDP(s : AnsiString) : AnsiString;
implementation
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	function parseString(s : AnsiString):miniArr;
	//parseString memotong  string a1 | a2 | a3 | a4 | a5 menjadi array yang berisi [a1,a2,a3,a4,a5]
	var
		temp : miniArr;
		i,j,awalKata,banyakHuruf,panjang : integer;
	begin
		//awal baris = i, awal kolom = j
		i := 1; j := 1;
		awalKata := 1; banyakHuruf := 1;
		panjang := length(s); //length mengembalikan panjang string
		//traversal dari i = 1 sampai akhir string, pake while buat jaga jaga aja
		while(i <= panjang) do begin
			//jika karakter ke i adalah | maka potong string dari indeks (awalKata) sepanjang (banyakHuruf) lalu dimasukkan ke array bernama temp
			if(s[i] = '|') then begin
				//setLength berguna untuk mengatur panjang array dinamis, dalam kasus ini panjang temp diset menjadi j
				SetLength(temp,j);
				//ini pake matematika, kenapa isi -1, karena sebelum | ada spasi, makanya dikurang 1
				banyakHuruf := i-awalKata-1;
				//copy syntaxnya Copy(s, i, n) outputya berupa string potongan dari s dari indeks ke-i dan panjang n huruf
				temp[j-1] := Copy(s,awalKata,banyakHuruf);
				//naikan variable awal kata sebanyak 2, karena setelah | ada spasi lagi
				awalKata := i+2;
				j += 1;
			end else begin
				//cek jika sudah sampai di ujung, maka langsung potong string s dari awalKata sampai akhir, lalu simpann di array temp
				if(i = panjang) then begin
					SetLength(temp,j);
					banyakHuruf := i-awalKata+1;
					temp[j-1] := Copy(s,awalKata,banyakHuruf);
				end;
			end;
			i += 1;
		end;
		parseString := temp;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure delStrukDat(var arr : strukDat; pos : longint);
	//menghapus 1 elemen dengan indeks pos untuk tipe data strukDat
	//I.S : arr terdefinisi, terisi penuh
	//F.S : elemen dengan indeks pos hilang dari arr
	var
		i : longint;
	begin
		for i := pos to high(arr)-1 do begin
			//geser semua elemen ke atas sebanyak 1 posisi
			arr[i] := arr[i+1];
		end;
		//memotong array paling terakhir dengan memperpendek panjang array
		setLength(arr, length(arr)-1);
	end;
	
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
	function isKabisat(tahun:integer):boolean;
	begin
		isKabisat:= ((tahun mod 400)=0) or (((tahun mod 400)<>0) and ((tahun mod 100)<>0) and ((tahun mod 4)=0));
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure tambahHari(var tanggal:ansistring);
	//menambah hari sebanyak 1
	//I.S : tanggal terdefinisi dan valid
	//F.S : tanggal menjadi tanggal esok harinya
	var
		sekarang:penanggalan;
	begin	
		ambilHari(tanggal,sekarang);
			if (sekarang.h=31) and (sekarang.b=12) then
			begin
				sekarang.h:=1;
				sekarang.b:=1;
				sekarang.t+=1;
			end	else if ((sekarang.h=31) and ((sekarang.b=1)or(sekarang.b=3)or(sekarang.b=5)or(sekarang.b=7)or(sekarang.b=8)or(sekarang.b=10)))
				 or ((sekarang.h=30) and ((sekarang.b=4)or(sekarang.b=6)or(sekarang.b=9)or(sekarang.b=11)))
				 or (isKabisat(sekarang.t) and (sekarang.b=2) and (sekarang.h=29))
				 or ((isKabisat(sekarang.t)=false) and (sekarang.b=2) and (sekarang.h=28)) then
			begin
				sekarang.h:=1;
				sekarang.b+=1;		
			end else begin
				sekarang.h+=1;
			end;
		tanggal:='';
		if (sekarang.h<10) then tanggal+='0'+inttostr(sekarang.h)+'/' else tanggal+=inttostr(sekarang.h)+'/';
		if (sekarang.b<10) then tanggal+='0'+inttostr(sekarang.b)+'/' else tanggal+=inttostr(sekarang.b)+'/';
		if (sekarang.t<10) then tanggal+='000'+inttostr(sekarang.t) 
		else if (sekarang.t<100) then tanggal+='00'+inttostr(sekarang.t)
		else if (sekarang.t<1000) then tanggal+='0'+inttostr(sekarang.t) 
		else tanggal+=inttostr(sekarang.t);
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure ambilHari(tanggal:ansistring;var sekarang:penanggalan);
	//mengubah format tanggal dari string menjadi tipe data penanggalan agar bisa diproses
	//I.S : tanggal terdefinisi dan format benar
	//F.S : variable sekarang berisi tipe data penanggalan dari variable tanggal
	var 
		temp:string;
		i:integer;
	begin
		i:=0;
		temp:='';
			for i:=0 to length(tanggal) do 			//membuang '/' dari penanggalan
			begin	
			if (tanggal[i]<>'/') then temp+=tanggal[i];
			end;
		val((temp[2]+temp[3]),sekarang.h);				//bagian aneh perlu diteliti
		val((temp[4]+temp[5]),sekarang.b);
		val((temp[6]+temp[7]+temp[8]+temp[9]),sekarang.t);
	end;	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	procedure urut(var list: strukDat);
	//mengurutkan strukDat
	//I.S : strukDat terdefinisi
	//F.S : strukDat terurut sesuai kolom ke 0
	var
		i,j:integer;
		temp : array of AnsiString;//variabel sementara untuk tukar
		//algoritma
	begin
		//algoritma bubble sort
		for i:= (length(list)-1) downto 1 do //lakukan n-1 kali dengan n jumlah data
		begin
			for j:=0 to (i-1) do //dicek untuk semua data sampai i-1
			begin
				if (list[j][0]>list[j+1][0]) then
				begin //ini menukar jika di depan lebihbesar
						temp:= list[j];
						list[j] := list[j+1];
						list[j+1] := temp;
				end;
			end;
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	function isThere(x : string; T : strukDat) : Boolean;
	//fungsi ini digunakan untuk memastikan apakah nama bahan ada pada daftar resep
	//fungsi ini juga digunakan untuk memastikan bahwa bahan yang di input dari pengguna ada pada file bahan mentah
	//KAMUS LOKAL
	var
	i,neff : longint;
	ada : boolean;
	//ALGORITMA
	begin
		neff := High(T);
		i:=0;
		ada := false; //asumsi ga ada
		while (i<=neff) and not(ada) do
		begin
			if (lowercase(x) = lowercase(T[i][0])) then
			begin
				ada:=True;
			end else begin
			i:=i+1;
			end;
		end;
		//return nilai
		isThere := ada;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	function idxStrukDat(x : string; dat : strukDat;kolom : longint) : longint;
	var
		i,hasil : longint;
		found : boolean;
	begin
		hasil := -1;
		i := low(dat);
		found := false;
		while( (i <= high(dat)) and not(found) ) do begin
			if( lowerCase(dat[i][kolom]) = lowerCase(x) ) then begin
				hasil := i;
				found := true;
			end else begin
				i += 1;
			end;
		end;
		idxStrukDat := hasil;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	function hargaBahan (x : string ; T : strukDat) : longint;
	//x adalah nama bahan yang dicari
	//fungsi ini digunakan untuk mencari harga dari bahan mentah, harga bahan mentah terdapat pada kolom 2 file bahan mentah
	//asumsu bahan pada bahan mentah dan bahan olahan berbeda
	//KAMUS LOKAL
	var
	i,neff : longint;
	found : Boolean;
	harga	: longint;
	//ALGORITMA
	begin
		neff := High(T);
		i:=0;
		found := false;
		harga := 0;
		while (i<=neff) and not(found) do 
		begin
			if (lowercase(x) = lowercase(T[i][0])) then
			begin
				harga := StrToInt(T[i][1]); //memasukkan harga bahan mentah
				found := True;
			end;
			i:=i+1;
		end;
		//return nilai
		hargaBahan := harga;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	function sugesti(s : AnsiString) : AnsiString;
	var
		i,j,k,maksSimilar,similar,idxSimilar: longint;
		command : miniArr;
	begin
		//inisialisasi command
		setLength(command,15);
		command[0] := 'belibahan';command[1] := 'save';command[2] := 'cariresep';
		command[3] := 'tidur';command[4] := 'lihatinventori';command[5] := 'lihatresep';
		command[6] := 'istirahat';command[7] := 'makan';command[8] := 'tambahresep';
		command[9] := 'upgradeinventori';command[10] := 'lihatstatistik';command[11] := 'olahbahan';
		command[12] := 'jualbahan';command[13] := 'jualresep';command[14] := 'stopsimulasi';
		//mulai algoritma
		idxSimilar := -1;
		maksSimilar := 3;
		for i := low(command) to high(command) do begin
			for j := 0 to max(length(s),length(command[i]))-3 do begin
				similar := 0;
				if(length(s) > length(command[i])) then begin
					for k := 1 to min(length(s)-j,length(command[i])) do begin
						if(command[i][k] = s[k+j]) then begin
							similar += 1;
						end;
					end;
				end else begin
					for k := 1 to min(length(command[i])-j,length(s)) do begin
						if(command[i][k+j] = s[k]) then begin
						similar += 1;
						end;
					end;
				end;
				if(similar >= maksSimilar) then begin
						idxSimilar := i;
						//writeln(command[idxSimilar],' mirip dengan ',s,' dengan nilai : ',similar,' dan j : ',j);
						maksSimilar := similar;
				end;
			end;
		end;
		if(not(idxSimilar = -1)) then begin
			sugesti := command[idxSimilar];
		end else begin
			sugesti := 'tidak ada';
		end;
	end;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
end.
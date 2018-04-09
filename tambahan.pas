unit tambahan;

interface
	const
	NMax = 100;
	type
		miniArr = record
			data : array[1..NMax] of AnsiString;
			nEff : longint;
		end;
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
		listBahan = record
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
	function parseString(s : AnsiString):miniArr;
	procedure delStrukDat(var arr:strukDat;x:longint);
	procedure tambahHari(var tanggal:ansistring);
	function isKabisat(tahun:integer):boolean;
	procedure ambilHari(tanggal:ansistring;var sekarang:penanggalan);
implementation
	function parseString(s : AnsiString):miniArr;
	//parseString memotong  string a1 | a2 | a3 | a4 | a5 menjadi array yang berisi [a1,a2,a3,a4,a5]
	var
		temp : miniArr;
		i,awalKata,banyakHuruf,panjang : integer;
	begin
		//awal baris = i, awal kolom = j
		i := 1; temp.nEff := 0;
		awalKata := 1; banyakHuruf := 1;
		panjang := length(s); //length mengembalikan panjang string
		//traversal dari i = 1 sampai akhir string, pake while buat jaga jaga aja
		while(i <= panjang) do begin
			//jika karakter ke i adalah | maka potong string dari indeks (awalKata) sepanjang (banyakHuruf) lalu dimasukkan ke array bernama temp
			if(s[i] = '|') then begin
				//setLength berguna untuk mengatur panjang array dinamis, dalam kasus ini panjang temp diset menjadi j
				temp.nEff += 1;
				//ini pake matematika, kenapa isi -1, karena sebelum | ada spasi, makanya dikurang 1
				banyakHuruf := i-awalKata-1;
				//copy syntaxnya Copy(s, i, n) outputya berupa string potongan dari s dari indeks ke-i dan panjang n huruf
				temp.data[temp.nEff] := Copy(s,awalKata,banyakHuruf);
				//naikan variable awal kata sebanyak 2, karena setelah | ada spasi lagi
				awalKata := i+2;
			end else begin
				//cek jika sudah sampai di ujung, maka langsung potong string s dari awalKata sampai akhir, lalu simpann di array temp
				if(i = panjang) then begin
					temp.nEff += 1;
					banyakHuruf := i-awalKata+1;
					temp.data[temp.nEff] := Copy(s,awalKata,banyakHuruf);
				end;
			end;
			i += 1;
		end;
		parseString := temp;
	end;
	
	procedure delStrukDat(var arr:strukDat;x:longint);
	var
		i:longint;
	begin
		for i:=x to high(arr)-1 do
		begin
			arr[i]:=arr[i+1];				
		end;
		SetLength(arr,length(arr)-1);		
	end;
	
	function isKabisat(tahun:integer):boolean;
	begin
		isKabisat:= ((tahun mod 400)=0) or (((tahun mod 400)<>0) and ((tahun mod 100)<>0) and ((tahun mod 4)=0));
	end;
	
	procedure tambahHari(var tanggal:ansistring);
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
	
	procedure ambilHari(tanggal:ansistring;var sekarang:penanggalan);
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
end.
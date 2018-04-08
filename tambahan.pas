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
	function parseString(s : AnsiString):miniArr;
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
end.
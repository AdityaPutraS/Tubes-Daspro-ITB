program main;
uses fitur,tambahan,sistem,sysutils;
const
	banyakSimulasi = 3;
var
	nomor : longint;
	nomorSim, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint;
	sekarang : penanggalan;
	daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat;
	input,tanggal : AnsiString;
	sudahTidur : Boolean;
begin

	write('> Masukkan No. Simulasi : '); readln(nomor);
	if((nomor > 0) and (nomor < banyakSimulasi)) then 
	begin
		load(IntToStr(nomor),daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
		//load semua variable status yang diperlukan
		loadStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
		sudahTidur:=false;
		while((input <> 'exit') and (hariLewat <> 10)) do begin
			if(energi > 0) then begin
				//baca input
				write('> '); readln(input);
				input := LowerCase(input);//normalisasi input dengan mengubahnya menjadi huruf kecil semua
				case input of
					'belibahan' : beliBahan(daftarBahMentah,listInvMentah,listInvOlahan,maksInv,totBMentahBeli,totPengeluaran,energi, tanggal);
					'save'		: begin
								  //save semua variable status ke array status
								  saveStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
								  //save semua array ke file eksternal
								  save(IntToStr(nomor), daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
								  end;
					'cariresep' : cariresep(daftarResep);
					'tidur'		: tidur(tanggal,hariLewat,energi,daftarBahMentah,listInvMentah,listInvOlahan,sudahTidur);
				end;
		//		//energi berkurang setelah melakukan kegiatan
		//		energi -= 1; <- sebaiknya diimplementasi langsung di fungsinya
			end else begin
				//hari yang telah dilewati bertambah 1 & mengisi ulang energi menjadi 10
				writeln('> Hari telah berganti.');
				hariLewat += 1;
				energi := 10;
			end;
		end;
	end else begin
		writeln('> Nomor simulasi tidak valid.')
	end;
end.
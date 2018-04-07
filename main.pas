program main;
uses fitur,tambahan,sysutils;
type
	strukDat = array of array of AnsiString; //tipe data array dinamis 2 dimensi
var
	nomorSim, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang : longint;
	tanggal : AnsiString;
	daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status : strukDat;
	input : AnsiString;
begin
	//load data yang diperlukan
	load(daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
	//load semua variable status yang diperlukan
	loadStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
	while((input <> 'exit') and (hariLewat <> 10)) do begin
		if(energi > 0) then begin
			//baca input
			write('> '); readln(input);
			input := LowerCase(input);//normalisasi input dengan mengubahnya menjadi huruf kecil semua
			case input of
				'belibahan' : beliBahan(daftarBahMentah,listInvMentah,listInvOlahan,maksInv,totBMentahBeli,totPengeluaran,tanggal);
				'save'		: begin
					//save semua variable status ke array status
					saveStatus(status, nomorSim,tanggal, hariLewat, energi, maksInv, totBMentahBeli, totBOlahanBuat, totBOlahanJual, totResepJual, totPemasukan, totPengeluaran, totUang);
					//save semua array ke file eksternal
					save(daftarBahMentah, listInvMentah, daftarBahOlahan, listInvOlahan, daftarResep, status);
					end;
			end;
			//energi berkurang setelah melakukan kegiatan
			energi -= 1;
		end else begin
			//hari yang telah dilewati bertambah 1 & mengisi ulang energi menjadi 10
			hariLewat += 1;
			energi := 10;
		end;
	end;
end.
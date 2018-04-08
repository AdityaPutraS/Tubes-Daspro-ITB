program main;
//merupakan program utama dari Tubes Daspro
uses sysutils, sistem, tambahan;
var
	dafBMentah	: daftarBMentah;
	dafBOlah	: daftarBOlahan;
	invBMentah	: listBMentah;
	invBOlah	: listBOlahan;
	dafRes		: daftarResep;
	status		: statusPengguna;
	hari,energi,i	: longint;
begin
	//load semua data
	load(dafBMentah,dafBOlah,invBMentah,invBOlah,dafRes,status);
	{while(hari <= 10) do begin
	
	end;}
	save(dafBMentah,dafBOlah,invBMentah,invBOlah,dafRes,status);
end.
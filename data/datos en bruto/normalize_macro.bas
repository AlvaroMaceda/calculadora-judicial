' This macro helps with municipality names, transforming them to a "Normalized" version so you can search by name
' It's not perfect, but can save you a lot of works when working with raw data
' Put it on your libreoffice library so you can run it on multiple spreadsheets

' https://wiki.openoffice.org/wiki/Documentation/BASIC_Guide/Strings_(Runtime_Library)
Function Replace(Source As String, Search As String, NewPart As String)
  Dim Result As String
  Dim StartPos As Long
  Dim CurrentPos As Long
 
  Result = ""
  StartPos = 1
  CurrentPos = 1
 
  If Search = "" Then
    Result = Source
  Else 
    Do While CurrentPos <> 0
      CurrentPos = InStr(StartPos, Source, Search)
      If CurrentPos <> 0 Then
        Result = Result + Mid(Source, StartPos, _
        CurrentPos - StartPos)
        Result = Result + NewPart
        StartPos = CurrentPos + Len(Search)
      Else
        Result = Result + Mid(Source, StartPos, Len(Source))
      End If                ' Position <> 0
    Loop 
  End If 
 
  Replace = Result
End Function


function RemoveAccents(str)
	
	dim res As String
	dim i as Integer
	
	source = Array("Á","À","Â","Å","Ä","Ã","á","à","â","å","ä","ã","É","È","Ê","Ë","é","è","ê","ë","Í","Ì","Î","Ï","í","ì","î","ï","Ñ","ñ","Ó","Ò","Ô","Ö","Õ","ó","ò","ô","ö","õ","Ú","Ù","Û","Ü","ú","ù","û","ü","Ý","Ÿ","ý","ÿ")
	replacement = Array("A","A","A","A","A","A","a","a","a","a","a","a","E","E","E","E","e","e","e","e","I","I","I","I","i","i","i","i","N","n","O","O","O","O","O","o","o","o","o","o","U","U","U","U","u","u","u","u","Y","Y","y","y")
	
	res = str
	For i = 0 To UBound(source)
'		msgbox i
		res = Replace(res,source(i),replacement(i)
	Next
	
	RemoveAccents = res
	
end Function


function ArticleFirst(str)
	Dim res as String

	pos = InStr(1,str,",")
	If pos = 0 Then
		res = str
	else
		res = Trim(Mid(str,pos+1,len(str)-pos)) + " " + Trim(Left(str,pos-1))
	End If

	ArticleFirst = res

end Function


function NORMALIZE(str)

	dim res as String
	
	res = ArticleFirst(str)
	res = UCase(RemoveAccents(res))

	NORMALIZE = res

end Function


function NORMALIZE(str)

	dim res as String
	
	res = UCase(RemoveAccents(str))

	NORMALIZE = res

		
	

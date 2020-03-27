using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, MaxByteSize = 8000)]
public struct License: INullable, IBinarySerialize
{
    Int32 Id;
    String Title;
    public override string ToString()
    {
        // Заменить на собственный код
        return "License: " + Id + " " + Title.ToString();
    }

    public bool IsNull
    {
        get
        {
            // Введите здесь код
            return _null;
        }
    }

    public static License Null
    {
        get
        {
            License h = new License();
            h._null = true;
            return h;
        }
    }

    public static License Parse(SqlString s)
    {
        if (s.IsNull)
            return Null;
        License u = new License();
        string[] xy = s.Value.Split(",".ToCharArray());
        if (xy.Length > 0)
        {
            u.Id = Int32.Parse(xy[0]);
            u.Title = xy[1].ToString();
        }
        return u;
    }

    public void Read(System.IO.BinaryReader r)
    {
        int maxStringSize = 10;
        char[] chars;
        string stringValue;

        // Read the characters from the binary stream.
        this.Id = r.ReadInt32();
        chars = r.ReadChars(maxStringSize);


        // Build the string from the array of characters.
        stringValue = new String(chars, 0, chars.Length);

        // Set the object's properties equal to the values.
        this.Title = stringValue;
    }

    public void Write(System.IO.BinaryWriter w)
    {
        w.Write(this.Id);

        for (int i = 0; i < this.Title.Length; i++)
        {
            w.Write(this.Title[i]);
        }
    }

    // Закрытый член
    private bool _null;
}
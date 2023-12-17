#include <iostream>
#include <fstream>
#include <cstring>
// m - numarul de linii
// n - numarul de coloane
// p - numarul celulelor vii
using namespace std;
int f_binar(int nr)
{
    int v_binar=0,p=1,rest;
    while(nr)
    {
        rest=nr%2;
        v_binar+=rest*p;
        p=p*10;
        nr=nr/2;
    }
    return v_binar;
}
ifstream f("in.txt");
ofstream g("out.txt");
int mat[20][20],cop[20][20],v[400],val_binar,v_binar[11],len_v_ascii,id,nr_vii,m,n,p,k,i,j,x,y,sum_vecini;
char pwd[11];
int main()
{
    f>>m>>n>>p;
    for(i=1; i<=p; i++)
        {
            f>>x>>y;
            mat[x+1][y+1]=1;
        }
    f>>k;
    for(int pas=1; pas<=k; pas++)
    {
        for(i=1; i<=m; i++)
            for(j=1; j<=n; j++)
            {
                sum_vecini=mat[i-1][j-1]+mat[i-1][j]+mat[i-1][j+1]+mat[i][j-1]+mat[i][j+1]+mat[i+1][j-1]+mat[i+1][j]+mat[i+1][j+1];
                if(mat[i][j]==1)
                {
                    if(sum_vecini<2 || sum_vecini>3)
                        cop[i][j]=0;
                    else
                        cop[i][j]=1;
                }
                else if(sum_vecini==3)
                    cop[i][j]=1;
                else
                    cop[i][j]=0;
            }
        for(i=1; i<=m; i++)
            for(j=1; j<=n; j++)
                mat[i][j]=cop[i][j];
    }
    for(i=1; i<=m; i++)
    {
        for(j=1; j<=n; j++)
            g<<cop[i][j]<<" ";
        g<<endl;
    }
    for(i=0; i<=m+1; ++i)
        for(j=0; j<=n+1; ++j)
        {
            cout<<cop[i][j]<<" ";
            v[id++]=cop[i][j];
        }
    cout<<endl;
//in v avem cheia de criptare

    cout<<"Parola este: ";
    cin.getline(pwd,10);
    for(int poz=0;poz<strlen(pwd);poz++)
        v_binar[len_v_ascii++]=(int)(pwd[poz]);
    for(i=0; i<len_v_ascii; ++i)
        cout<<v_binar[i]<<" ";
    cout<<endl;
    for(i=0; i<len_v_ascii; ++i)
        {
            val_binar=f_binar(v_binar[i]);
            v_binar[i]=val_binar;
        }
    for(i=0; i<len_v_ascii; ++i)
        cout<<v_binar[i]<<" ";
    return 0;
}

#!/bin/bash
#Script para urna

Principal() {
  clear
  echo 
  echo                
  echo "      BEM VINDO AO ELEITORINEITOR 90000!"     
  echo                
  echo "        versão 1.0.0_beta"              
  echo "    Este consiste em um script/programa de adm. de eleição" 
  echo                    
  echo "  Informe uma opção:"           
  echo "  ========================================================="  
  echo "    Digite 1 para cadastrar"      
  echo "    Digite 2 para votar"          
  echo "    Digite 3 para apurar votos"           
  echo "    Digite 4 para criar/resetar banco"  
  echo "    Digite 5 para sair"
  echo
  echo -n "Qual a opcao desejada? "
  read opcao
  case $opcao in
    1) Processo1 ;;
    2) Processo2 ;;
    3) Processo3 ;;
    4) Processo4 ;;
    5) echo ; exit ;;
    *) echo "Opcao desconhecida." ; echo ; Principal ;;
  esac
}

Processo1() {
  clear

  variable=false
  variablen=false
  echo "Digite o nome do candidato: "
  read nome
  if [[ -z "$nome" ]]; then
  Processo1
  fi
  echo "Digite o numero do candidato"
  read num
  if [[ -z "$num" ]]; then
  Processo1
  fi
  if expr "$id" + 0  > /dev/null 2>&1 && [ $num -lt 100 ] && [ $num -gt 0 ]; then
   echo
   while read line 
    do  
      candidato=$( echo -e "$line" )
      number=$( echo $candidato| cut -d"&" -f 1 )
         if [ $number = $num ]; then
            echo "Numero de candidato já existe"
            variablen=true
         fi
      name=$( echo $candidato| cut -d"&" -f 2 )
         if [ "$name" = "$nome" ]; then
            echo "Nome de candidato já existe"
            variable=true
         fi
   done < banco.txt
   echo
   if [ "$variable" = false ] && [ "$variablen" = false ]; then
    text="0&$nome&$num"
    echo "$text" >> banco.txt
    echo
   else
    echo "Cancelando processo"
   fi
    echo
   else
    echo
    echo "Numero invalido, cancelando processo"
    echo
   fi

  echo -n "Iniciar processo novamente?(s/n)"
  read var
  case $var in
    s) Processo1 ;;
    n) Principal ;;
    *) echo "Opcao desconhecida." ; echo ; Principal ;;
  esac
}

Processo2() {
  clear
  
  echo "Digite o numero do candidato para votar (ou digite branco/nulo): "
  read num
  if [ "$num" != "" ]; then
    line=$( ls -l |grep "$num" banco.txt )
    if [ "$line" != "" ]; then
  echo
        name=$( echo $line| cut -d"&" -f 2 )
  qtd=$( echo $line| cut -d"&" -f 1 )
        echo "Deseja votar mesmo em "$name"?(s/n)"
  read voto
        if [ "$voto" = "s" ]; then
      echo
      newqtd=$(( $qtd+1 ))
      sed -i "/$name/s/$qtd/$newqtd/" banco.txt
        else
      echo "Cancelando processo"
        fi
    else
  echo "Candidato não encontrado, cancelando processo"
    fi
  else
    echo "Cancelando processo"
  fi
  echo

  echo -n "Iniciar processo novamente?(s/n)"
  read var
  case $var in
    s) Processo2 ;;
    n) Principal ;;
    *) echo "Opcao desconhecida." ; echo ; Principal ;;
  esac
}

Processo3() {
  clear

  linhas=$( wc -l banco.txt| cut -d"&" -f 1 )
  soma=0
  while read line 
  do  
      candidato=$( echo -e "$line" )
      qtd=$( echo $candidato| cut -d"&" -f 1 )
      soma=$(( $qtd+$soma ))
  done < banco.txt
  while read line 
  do  
      candidato=$( echo -e "$line" )
      name=$( echo $candidato| cut -d"&" -f 2 )
      qtd=$( echo $candidato| cut -d"&" -f 1 )
      if [ "$qtd" -ne "0" ]; then
        porc=$( echo "scale=1; (($qtd / $soma) * 100) " | bc )
  echo "O candidato "$name" conseguiu "$qtd" votos totalizando "$porc"% dos votos."
      else
  echo "O candidato "$name" não obteve nenhum voto"
      fi
      echo
  done < banco.txt
  echo

  echo -n "Voltar ao menu?(s/n)"
  read var
  case $var in
    s) Principal ;;
    n) Processo3 ;;
    *) echo "Opcao desconhecida." ; echo ; Principal ;;
  esac
}

Processo4() {
  clear

  echo "0&Branco&branco" > banco.txt
  echo "0&Nulo&nulo" >> banco.txt
  echo "Banco criado com sucesso"

  echo
  echo -n "Voltar ao menu?(s/n)"
  read var
  case $var in
    s) Principal ;;
    n) Processo4 ;;
    *) echo "Opcao desconhecida." ; echo ; Principal ;;
  esac
}

clear

Principal

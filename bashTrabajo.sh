#!/bin/bash

########## VARIABLES GLOBALES ##########
fdl=`echo $'\n>>'`
fdl=${fdl%.}
usuario=""

############# FUNCIONES ################
reemplazar_bind_vincha() {
echo "Se remplaza en el file tarjeta $1 tipo $2";
## 429 434
}
detectar_usuario() { 
	echo "Obteniendo el usuario sobre el que se trabajará"
	usuario="$(whoami)"
	echo "El usuario es: $usuario"
}
detectar_vincha() {
	local vincha
	local tarjeta_sonido
	vincha="$(aplay -l | grep 'USB Audio')"
	if [ ! -z "$vincha" ]
		then
			echo "Detectada: "
			echo "$vincha"
			[[ $vincha =~ ([[:digit:]]) ]]
			tarjeta_sonido="${BASH_REMATCH[1]}";
			echo "Toma tarjeta: $tarjeta_sonido"
			case $vincha in
				*"Jabra"*) reemplazar_bind_vincha $tarjeta_sonido "Headset" ;;
				*"Logitech"*) reemplazar_bind_vincha $tarjeta_sonido "Headphone" ;;
				*) echo "No matcheo con una vincha conocida";;
			esac
		else
			echo "No se detecto vincha.Saliendo..."
			exit 0
	fi
}
panel_pantalla() {
	detectar_usuario
	fecha=`date +%Y%m%d`
	echo "Backupeando archivos..."
	for archivos in /home/$usuario/.config/lxpanel/*
	do
		mv $archivos $archivos"Back"$fecha
	done
	echo "Ingrese clave de Administrador para reiniciar..."
	sudo reboot now
	
}
config_vincha() {
	detectar_usuario
	detectar_vincha
}
version() {
	echo "version inicial"
}
vincha_manual() {
	echo "Se debe conocer el identificado de la tarjeta y el tipo de Dispositivos."
	echo "Ambos datos los arroja la funcion automatica, el tipo de dispositivo puede variar en un jabra duo"
	echo "Luego esos datos se deben cargar en el ~/.config/openbox/lubuntu-rc.xml"
	echo "Buscar por xf86LowerAudio y xf86RaiseAudio, el primero decrementa"
	echo "Modificar la linea de la siguiente manera"
	echo "<command>amixer -c NUMERO_DE_TARJETA sset TIPO_DE_DIPOSITIVO 3%[+ O - DEPENDE DE LOWER O RAISE] unmute</command>"
	echo "ejemplo:"
	echo "<command>amixer -c 1 sset Headphone 3%+ unmute</command>"
	exit 0
}
########## FIN FUNCIONES #########
menu() {
	clear
	echo "1 - Configurar botones de volumen de la vincha"
	echo "2 - Reconfigurar escritorio"
	echo "3 - Versión"
	echo "4 - Configurar MANUAL botones de la vincha"
	echo "5 - Salir"
}

seleccionar_menu() {
	local opcion
	read -p "Seleccionar con teclas numéricas $fdl" opcion
	case $opcion in
	1) config_vincha ;;
	2) panel_pantalla ;;
	3) version ;;
	4) vincha_manual ;;
	5) exit 0 ;;
	gabi) echo "Version inicial 1-7-18 - Desarrollada por Gabriel Lourenço y Agustín Meinardo" ;;
	*) echo "Error..." && exit 0 ;;
	esac
}

############ Main #########
menu
seleccionar_menu

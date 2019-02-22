#!/system/bin/sh

# Copyright (c) 2017, Motorola Mobility LLC, All Rights Reserved.
#
# Date Created: 11/01/2017, Carrier Client ID matrix for Android 20170915
#
PATH=/sbin:/system/sbin:/system/bin:/system/xbin
export PATH

while getopts iosde op;
do
   case $op in
           i)  init_early_property=1;;
           o)  post_property_overlay=1;;
           s)  post_sprint_property=1;;
           d)  boot_complete_operation=1;;
           e)  demo_mode_operation=1;;
   esac
done
shift $((OPTIND-1))

# carrier and wave always set on early time (early than early-init)
carrier=`getprop ro.carrier`
boot_carrier=`getprop ro.boot.carrier`
wave=`getprop ro.mot.product_wave`
carrierid=`getprop persist.carrier.carrierid`
sprintclientid=`getprop persist.carrier.google.searchid`
omadm_operator=`getprop persist.omadm.operator.numeric`

# Set Google GMS clientid properties -- early-init
set_google_clientid_properties ()
{
    # Set default build properties to configure client ID values for GMS on Android
    setprop ro.mot.gms.clientidbase android-motorola

    # Set client ID properties base on region carrier
    case $carrier in
        # North America Region - Amazon
        amz )
            setprop ro.mot.gms.clientidbase.ms android-motorola
            setprop ro.mot.gms.clientidbase.am android-motorola
        ;;
        # North America Region - AT&T
        att )
            # base on product wave
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.am android-att-us
                    setprop ro.mot.gms.clientidbase.ms android-att-us-revc
                ;;
                2017.[3-4] )
                    setprop ro.mot.gms.clientidbase.am android-att-us
                    setprop ro.mot.gms.clientidbase.ms android-att-us
                ;;
                * )
                    # legacy
                    setprop ro.mot.gms.clientidbase.am android-att-us
                    setprop ro.mot.gms.clientidbase.ms android-att-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # North America Region - AT&T (AIO prepaid)
        aio )
            # wave > 2017.4
            setprop ro.mot.gms.clientidbase.ms android-att-aio-us
            setprop ro.mot.gms.clientidbase.am android-att-aio-us
        ;;
        # North America Region - Comcast
        comcast )
            setprop ro.mot.gms.clientidbase.ms android-comcast-us-revc
        ;;
        # North America Region - Cricket
        cricket )
            # wave > 2017.4
            setprop ro.mot.gms.clientidbase.ms android-cricket-us-revc
            setprop ro.mot.gms.clientidbase.am android-cricket
        ;;
        # North America Region - Google Project Fi
        fi )
            setprop ro.mot.gms.clientidbase.ms android-fi
        ;;
        # North America Region - Sprint
        sprint )
            # Set sprint alone
        ;;
        # North America Region - TMO
        tmo )
            case $wave in
                # wave > 2017.4
                2017.4|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-tmus-us-revc
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-hms-tmobile-us
                    setprop ro.mot.gms.clientidbase.am android-tmobile-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-hms-tmobile-us
                    setprop ro.mot.gms.clientidbase.am android-tmobile-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # North America Region - USC
        usc )
            setprop ro.mot.gms.clientidbase.am android-uscellular-us
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-uscellular-us-revc
                ;;
                2017.[3-4] )
                    setprop ro.mot.gms.clientidbase.ms android-uscellular-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-uscellular-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # North America Region - Verizon
        vzw )
            setprop ro.mot.gms.clientidbase.ms android-verizon
            setprop ro.mot.gms.clientidbase.am android-verizon
            case $wave in
                # wave > 2017.3
                2017.[3-4]|201[8-9].[1-4] )
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-verizon
                ;;
            esac
        ;;
        # North America Region - Metropcs
        metropcs )
            case $wave in
                # wave > 2017.4
                2017.4|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-mpcs-us-revc
                ;;
                2017.[2-3] )
                    setprop ro.mot.gms.clientidbase.am android-motorola
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.am android-motorola
                    setprop ro.mot.gms.clientidbase.ms android-motorola
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # North America Region - Rogers Canada
        rcica )
            case $wave in
                # wave > 2017.4
                2017.4|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-rogers-ca-revc
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-rogers-ca
                    setprop ro.mot.gms.clientidbase.am android-rogers-ca
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-rogers-ca
                    setprop ro.mot.gms.clientidbase.am android-rogers-ca
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # North America Region - Bell Canada
        bwaca )
            case $wave in
                # wave > 2017.4
                2017.4|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-bell-ca-revc
                ;;
                2017.3 )
                    setrpop ro.mot.gms.clientidbase.ms android-bell-ca
                    setprop ro.mot.gms.clientidbase.am android-bell-ca
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-bell-ca
                    setprop ro.mot.gms.clientidbase.am android-bell-ca
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # EMEA - eegb
        eegb )
            case $wave in
                2018.4|2019.[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-ee-uk-revc
                ;;
                # 2018.4 >wave > 2017.4
                2017.4|2018.[1-3] )
                    setprop ro.mot.gms.clientidbase.ms android-dt-{country}-revc
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-orange-gb
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-tmobile-{country}
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                    setprop ro.mot.gms.clientidbase.gmm android-tmobile-{country}
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # EMEA - oraeu orafr oraes
        oraes|oraeu|orafr )
            case $wave in
                # wave > 2017.3
                2017.[3-4]|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-orange-{country}-revc
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-orange-{country}
                    setprop ro.mot.gms.clientidbase.am android-orange-{country}
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # EMEA - dteu, tmde
        dteu|tmde )
            case $wave in
                # wave > 2017.4
                2017.4|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-dt-{country}-revc
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-tmobile-{country}
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-tmobile-{country}
                    setprop ro.mot.gms.clientidbase.am android-tmobile-{country}
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # EMEA - vfeu
        vfeu )
            case $wave in
                # wave > 2018.4
                2018.4|2019.[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-vf-{country}-revc
                ;;
            esac
        ;;
        # EMEA - altfr vffr
        vffr|altfr )
            case $wave in
                # 2018.2 > wave > 2017.3
                2017.[3-4]|2018.[1-2] )
                    setprop ro.mot.gms.clientidbase.ms android-hms-vf-fr
                    setprop ro.mot.gms.clientidbase.am android-sfr-fr
                # wave > 2017.3
                ;;
                201[4-6].[1-4]|2017.[1-2] )
                    setprop ro.mot.gms.clientidbase.ms android-hms-vf-fr
                    setprop ro.mot.gms.clientidbase.am android-sfr-fr
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # Ameria Movil - Claro, Comcel, Telcel, Porta, Tracfone
        amovil|amxar|amxbr|amxcl|amxco|amxla|amxmx|amxpe|openmx|tracfone )
            case $wave in
                # wave > 2017.3
                2017.[3-4]|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-americamovil-{country}-revc
                    setprop ro.mot.gms.clientidbase.am android-americamovil-{country}
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-americamovil-{country}
                    setprop ro.mot.gms.clientidbase.am android-americamovil-{country}
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # 3GB
        3gb )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-h3g-{country}-revc
                ;;
                2017.[3-4] )
                    setprop ro.mot.gms.clientidbase.am android-h3g-{country}
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-h3g-{country}
                    setprop ro.mot.gms.clientidbase.am android-h3g-{country}
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # Wind / 3 Italy
        windit )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-h3g-{country}-revc
                ;;
                2017.[3-4] )
                    setprop ro.mot.gms.clientidbase.am android-motorola
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.am android-motorola
                    setprop ro.mot.gms.clientidbase.ms android-motorola
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # Telstra AU
        telstra )
            case $wave in
                # wave > 2017.4
                2017.4|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.am android-telstra-au
                    setprop ro.mot.gms.clientidbase.ms android-telstra-au-revc
                    setprop ro.mot.gms.clientidbase.wal android-telstra-au
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.am android-telstra-au
                    setprop ro.mot.gms.clientidbase.ms android-telstra-au
                    setprop ro.mot.gms.clientidbase.wal android-telstra-au
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.am android-telstra-au
                    setprop ro.mot.gms.clientidbase.ms android-telstra-au
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
        # TIM Italy - timit
        timit )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-tim-it-revc
                ;;
            esac
        ;;
        # Bouygues France - bouyfr
        bouyfr )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-bouygues-fr-revc
                ;;
            esac
        ;;
        # Telus Canada - tkpca
        tkpca )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms android-telus-ca-revc
                ;;
            esac
        ;;
        # Vodafone Australia - vfau
        vfau )
            case $wave in
                # wave > 2018.3
                201[8].[3-4]|2019.[1-4] )
                   setprop ro.mot.gms.clientidbase.ms android-vf-au-revc
                ;;
            esac
        ;;
        # telenor - SE,DK,NO
        telhu|teleu )
            case $wave in
                # wave > 2018.4
                2018.4|2019.[1-4] )
                   setprop ro.mot.gms.clientidbase.ms android-telenor-{country}-revc
                ;;
            esac
        ;;
        # GMS properties by default
        * )
            case $wave in
                2017.[3-4]|201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.am android-motorola
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
                ;;
                2017.2 )
                    setprop ro.mot.gms.clientidbase.am android-motorola
                    setprop ro.mot.gms.clientidbase.ms android-motorola-rev2
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.am android-motorola
                    setprop ro.mot.gms.clientidbase.ms android-motorola
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                    setprop ro.mot.gms.clientidbase.yt android-motorola
                ;;
            esac
        ;;
    esac # end $carrier for GMS
}

# Set sprint client id base on persist.carrier.carrierid
set_sprint_google_clientid_properties ()
{
    case $carrierid in
        SPRINT )
            case $wave in
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms $sprintclientid
                ;;
                2017.4 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-us-revc
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-us-revc
                    setprop ro.mot.gms.clientidbase.am android-sprint-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-us
                    setprop ro.mot.gms.clientidbase.am android-sprint-us
                    setprop ro.mot.gms.clientidbase.yt android-sprint-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                ;;
            esac
        ;;
        BOOST )
            case $wave in
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms $sprintclientid
                ;;
                2017.4 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-us-revc
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-boost-us-revc
                    setprop ro.mot.gms.clientidbase.am android-boost-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-boost-us
                    setprop ro.mot.gms.clientidbase.am android-boost-us
                    setprop ro.mot.gms.clientidbase.yt android-boost-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                ;;
            esac
        ;;
        VIRGIN )
            case $wave in
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms $sprintclientid
                ;;
                2017.4 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-us-revc
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-virgin-us-revc
                    setprop ro.mot.gms.clientidbase.ma android-virgin-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-virgin-us
                    setprop ro.mot.gms.clientidbase.am android-virgin-us
                    setprop ro.mot.gms.clientidbase.yt android-virgin-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                ;;
            esac
        ;;
        SPRPRE )
            case $wave in
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms $sprintclientid
                ;;
                2017.4 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-us-revc
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-us-revc
                    setprop ro.mot.gms.clientidbase.am android-sprint-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-mvno-us
                    setprop ro.mot.gms.clientidbase.am android-sprint-mvno-us
                    setprop ro.mot.gms.clientidbase.yt android-sprint-mvno-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                ;;
            esac
        ;;
        310470|312420|312570|310580|312720|310130|311910|311450|311670|311230 )
            case $wave in
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms $sprintclientid
                ;;
                2017.4 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-cca-us
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-cca-us
                    setprop ro.mot.gms.clientidbase.am android-sprint-cca-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-cca-us
                    setprop ro.mot.gms.clientidbase.am android-sprint-cca-us
                    setprop ro.mot.gms.clientidbase.yt android-sprint-cca-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                ;;
            esac
        ;;
        # for any new carrier id, just set it to the value in Chameleon
        * )
            setprop ro.mot.gms.clientidbase.ms $sprintclientid
        ;;
    esac # end carrierid for sprint

    case $omadm_operator in
        310000 )
            case $wave in
                201[8-9].[1-4] )
                    setprop ro.mot.gms.clientidbase.ms $sprintclientid
                ;;
                2017.4 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-cca-us
                ;;
                2017.3 )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-cca-us
                    setprop ro.mot.gms.clientidbase.am android-sprint-cca-us
                ;;
                * )
                    setprop ro.mot.gms.clientidbase.ms android-sprint-mvno-us
                    setprop ro.mot.gms.clientidbase.am android-sprint-mvno-us
                    setprop ro.mot.gms.clientidbase.yt android-sprint-mvno-us
                    setprop ro.mot.gms.clientidbase.gmm android-motorola
                ;;
            esac
        ;;
    esac
}

# Set additional properties base on carrier -- early-init
set_carrier_readonly_properties ()
{
    case $boot_carrier in
        att )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.config.ringtone ATT_Firefly.ogg
                    setprop ro.mot.config.notification_sound ATT_Chat_In.ogg
                    setprop ro.facebook.partnerid att:4b2a1409-4fa0-4d4c-a184-95f0f26d4192
                ;;
            esac

            setprop ro.csc.amazon.partnerid att
        ;;
        attmx )
            setprop ro.csc.amazon.partnerid attmx
        ;;
        cricket )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.config.ringtone CricketRing.ogg
                    setprop ro.mot.config.notification_sound CricketPiano.ogg
                    setprop ro.facebook.partnerid cricket:b8be48cb-7b34-13cd-1ed7-4b90bc649fcd
                ;;
            esac

            setprop ro.csc.amazon.partnerid cricket
        ;;
        tmo )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop ro.mot.config.ringtone TJINGLE.ogg
                    setprop ro.facebook.partnerid t-mobile:05b925b2-7fe4-44c4-9a36-7f101502cdb2
                ;;
            esac

            setprop ro.csc.amazon.partnerid tmobile
        ;;
        metropcs )
            setprop ro.facebook.partnerid metropcs:d23ba4e0-3b37-4a4b-9ccb-7be7680cb157
        ;;
        usc )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    setprop cdma.operator.numeric 311580
                    setprop ro.cdma.home.operator.numeric 311580
                    setprop ro.cdma.home.operator.alpha "U.S. Cellular"
                ;;
            esac

            setprop ro.csc.amazon.partnerid uscc
        ;;
        playpl )
            case $wave in
                # wave > 2018.4
                2018.4|2019.[1-4] )
                    setprop ro.mot.config.ringtone Play.ogg
                    setprop ro.mot.config.ringtone_2 Play.ogg
                    setprop ro.mot.config.notification_sound Play_mms.ogg
                ;;
            esac
        ;;
        bouyfr )
            setprop ro.location.providers.allowed gps
        ;;
        oraeu )
            setprop media.httplive.kdlblocksize 1920
            setprop ro.product.brand1 orange
        ;;
        oraes|orafr )
            setprop media.httplive.kdlblocksize 1920
        ;;
        reteu|amxmx )
            setprop persist.radio.suppress_ussd_rel 1
        ;;
        sprint )
            setprop ro.csc.amazon.partnerid sprint
        ;;
        vzw )
            setprop ro.csc.amazon.partnerid verizon
        ;;
        rcica )
            setprop ro.csc.amazon.partnerid rogers
        ;;
        tkpca )
            setprop ro.csc.amazon.partnerid telus
        ;;
        tefes )
            setprop ro.csc.amazon.partnerid telefonica
        ;;
        timit )
            setprop ro.csc.amazon.partnerid timit
            setprop ro.facebook.partnerid tim-italy:f6b4b437-f40e-cf6c-618a-51eba0198794
        ;;
        windit )
            setprop ro.csc.amazon.partnerid 3it
        ;;
    esac

    case $carrierid in
        BOOST )
            setprop ro.csc.amazon.partnerid boost
        ;;

        VIRGIN )
            setprop ro.csc.amazon.partnerid virgin
        ;;
    esac
}

# Additional operation for carrier when phone boot complete
set_boot_complete_operation ()
{
    case $carrier in
        attmx | rcica | usc )
            case $wave in
                # wave > 2018.1
                201[8-9].[1-4] )
                    if [ -f  /oem/$carrier/amzn.mshop.properties ]; then
                         mkdir -p /data/vendor/Amazon\ Video/raw/
                         chown system:system /data/vendor/Amazon\ Video/
                         chmod 0755 /data/vendor/Amazon\ Video/
                         chown system:system /data/vendor/Amazon\ Video/raw/
                         chmod 0755  /data/vendor/Amazon\ Video/raw/
                         ln -s /oem/$carrier/amzn.mshop.properties data/vendor/Amazon\ Video/raw/amzn.mshop.properties
                    fi
                ;;
            esac
        ;;
        acg | lra )
            setprop ril.subscription.types RUIM
        ;;
        tmo | metropcs )
            echo 55 > /sys/class/power_supply/battery/device/force_max_chrg_temp
        ;;
    esac
}

set_demo_mode_operation ()
{
    if [ $carrier == vzw ]; then
        echo 35 > /sys/class/power_supply/battery/device/force_demo_mode
    else
        echo 70 > /sys/class/power_supply/battery/device/force_demo_mode
    fi
}

# The main code
if [ ! -z "$init_early_property" ]; then
    set_carrier_readonly_properties
    return 0
fi

if [ ! -z "$post_property_overlay" ]; then
    set_google_clientid_properties
    return 0
fi

if [ ! -z "$post_sprint_property" ]; then
   if [ "$carrier" == "sprint" ]; then
      set_sprint_google_clientid_properties
   fi
   return 0
fi

if [ ! -z "$boot_complete_operation" ]; then
   set_boot_complete_operation
   return 0
fi

if [ ! -z "$demo_mode_operation" ]; then
   set_demo_mode_operation
   return 0
fi

return 0

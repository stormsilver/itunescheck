FasdUAS 1.101.10   ��   ��    k             l     �� ��    O I script to search out the next album in a playlist, then play that track        	  l     ������  ��   	  
�� 
 l    K ��  O     K    k    J       l   �� ��    "  bring =iTunes to the front          l   �� ��     activate         l   �� ��    c ] stop the player and figure out what the name of the Album of the currently playing track is          I   	������
�� .hookStopnull        null��  ��        r   
     c   
     n   
    !   1    ��
�� 
pAlb ! 1   
 ��
�� 
pTrk  m    ��
�� 
TEXT  o      ���� 0 	albumname 	albumName   " # " l   �� $��   $ . ( duplicate this for comparison purposes     #  % & % r     ' ( ' o    ���� 0 	albumname 	albumName ( o      ���� (0 nexttrackalbumname nextTrackAlbumName &  ) * ) l   �� +��   + i c repeat this next section as long as the next track's album name is the same as the original track     *  , - , V    B . / . k     = 0 0  1 2 1 l     �� 3��   3 1 + advance to the next track in the playlist     2  4 5 4 I    %������
�� .hookNextnull        null��  ��   5  6 7 6 l  & &�� 8��   8 B < figure out what the name of the Album of this new track is     7  9 : 9 r   & / ; < ; c   & - = > = n   & + ? @ ? 1   ) +��
�� 
pAlb @ 1   & )��
�� 
pTrk > m   + ,��
�� 
TEXT < o      ���� (0 nexttrackalbumname nextTrackAlbumName :  A B A l  0 0�� C��   C 4 . if there is no album name, ignore this track     B  D�� D Z   0 = E F���� E =  0 3 G H G o   0 1���� (0 nexttrackalbumname nextTrackAlbumName H m   1 2 I I       F r   6 9 J K J o   6 7���� 0 	albumname 	albumName K o      ���� (0 nexttrackalbumname nextTrackAlbumName��  ��  ��   / =    L M L o    ���� (0 nexttrackalbumname nextTrackAlbumName M o    ���� 0 	albumname 	albumName -  N O N l  C C�� P��   P : 4 play the new track when a different album is found     O  Q�� Q I  C J�� R��
�� .hookPlaynull    ��� obj  R 1   C F��
�� 
pTrk��  ��    m      S S�null     � ��  �
iTunes.app  P� �0    ���� Y � �0                 ���(.��� �)hook   alis    H  Locutus                    �3�~H+    �
iTunes.app                                                      ���>/        ����  	                Media     �4@�      ��      �     %Locutus:Applications:Media:iTunes.app    
 i T u n e s . a p p    L o c u t u s  Applications/Media/iTunes.app   / ��  ��  ��       �� T U V W����   T ��������
�� .aevtoappnull  �   � ****�� 0 	albumname 	albumName�� (0 nexttrackalbumname nextTrackAlbumName��   U �� X���� Y Z��
�� .aevtoappnull  �   � **** X k     K [ [  
����  ��  ��   Y   Z 
 S�������������� I��
�� .hookStopnull        null
�� 
pTrk
�� 
pAlb
�� 
TEXT�� 0 	albumname 	albumName�� (0 nexttrackalbumname nextTrackAlbumName
�� .hookNextnull        null
�� .hookPlaynull    ��� obj �� L� H*j O*�,�,�&E�O�E�O )h�� *j O*�,�,�&E�O��  �E�Y h[OY��O*�,j 	U V ( Legion Of Boom                   W " Tweekend                  ��   ascr  ��ޭ
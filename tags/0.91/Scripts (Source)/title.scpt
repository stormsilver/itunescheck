FasdUAS 1.101.10   ��   ��    l    n ��  O     n    Z    m  �� 	  >   	 
  
 l    ��  1    ��
�� 
pStT��    m    ��
�� 
msng  k    c       l   �� ��    I C okay, we're streaming. let's grab the string the server sent to us         r        l    ��  c        l    ��  1    ��
�� 
pStT��    m    ��
�� 
TEXT��    o      ���� 0 
titlewords 
titleWords      l   �� ��    y s Now we'll walk through the string and look for " - ", which most servers use to delimit the artist from the title.         Y    ` ��   ��  Z   $ [ ! "���� ! F   $ C # $ # l  $ / %�� % B  $ / & ' & l  $ ' (�� ( [   $ ' ) * ) o   $ %���� 0 i   * m   % &���� ��   ' l  ' . +�� + l  ' . ,�� , I  ' .�� -��
�� .corecnte****       **** - n   ' * . / . 2  ( *��
�� 
cha  / o   ' (���� 0 
titlewords 
titleWords��  ��  ��  ��   $ =  2 A 0 1 0 n   2 ? 2 3 2 7  3 ?�� 4 5
�� 
ctxt 4 o   7 9���� 0 i   5 l  : > 6�� 6 [   : > 7 8 7 o   ; <���� 0 i   8 m   < =���� ��   3 o   2 3���� 0 
titlewords 
titleWords 1 m   ? @ 9 9 	  -     " k   F W : :  ; < ; l  F F�� =��   = d ^ we found it. What we'll assume is that everything after the dash is the the title of the song    <  >�� > L   F W ? ? n   F V @ A @ 7  G U�� B C
�� 
ctxt B l  K O D�� D [   K O E F E o   L M���� 0 i   F m   M N���� ��   C l  P T G�� G l  P T H�� H n   P T I J I 1   R T��
�� 
leng J o   P R���� 0 
titlewords 
titleWords��  ��   A o   F G���� 0 
titlewords 
titleWords��  ��  ��  �� 0 i    m    ����    l    K�� K I   �� L��
�� .corecnte****       **** L n     M N M 2   ��
�� 
cha  N o    ���� 0 
titlewords 
titleWords��  ��  ��     O P O l  a a�� Q��   Q L F we couldn't find a dash... so we'll just return the whole damn thing.    P  R�� R L   a c S S o   a b���� 0 
titlewords 
titleWords��  ��   	 k   f m T T  U V U l  f f�� W��   W ` Z we're not streaming so we'll return the title of whatever happens to be playing right now    V  X�� X L   f m Y Y l  f l Z�� Z n   f l [ \ [ 1   i k��
�� 
pnam \ l  f i ]�� ] 1   f i��
�� 
pTrk��  ��  ��    m      ^ ^�null     � �� �8
iTunes.app���    �%���(��� ���     )       ��(�$�����0ohook   alis    H  Locutus                    �,��H+   �8
iTunes.app                                                      F����;        ����  	                Media     �-/4      ���     �8  	�  %Locutus:Applications:Media:iTunes.app    
 i T u n e s . a p p    L o c u t u s  Applications/Media/iTunes.app   / ��  ��       �� _ ` a��   _ ����
�� .aevtoappnull  �   � ****�� 0 
titlewords 
titleWords ` �� b���� c d��
�� .aevtoappnull  �   � **** b k     n e e  ����  ��  ��   c ���� 0 i   d  ^�������������� 9��������
�� 
pStT
�� 
msng
�� 
TEXT�� 0 
titlewords 
titleWords
�� 
cha 
�� .corecnte****       ****
�� 
ctxt
�� 
bool
�� 
leng
�� 
pTrk
�� 
pnam�� o� k*�,� \*�,�&E�O Kk��-j kh  �l��-j 	 �[�\[Z�\Z�l2� �& �[�\[Z�m\Z��,2EY h[OY��O�Y 	*�,�,EU a ? %Funked Up Radio  [AIM: funkedupradio]                  ascr  ��ޭ
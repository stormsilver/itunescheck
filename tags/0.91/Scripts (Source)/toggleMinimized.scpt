FasdUAS 1.101.10   ��   ��    k             l     �� ��     set shouldZoom to false       	  l     ������  ��   	  
  
 l    + ��  O     +    Z    *  ��   >       n    
    1    
��
�� 
wshd  l    ��  4   �� 
�� 
cwin  m    ���� ��    m   
 ��
�� boovtrue  r        m    ��
�� boovtrue  n          1    ��
�� 
wshd  l    ��  4   �� 
�� 
cwin  m    ���� ��  ��    k    *        r    " ! " ! m    ��
�� boovfals " n       # $ # 1    !��
�� 
wshd $ l    %�� % 4   �� &
�� 
cwin & m    ���� ��      ' ( ' I  # (������
�� .miscactvnull��� ��� null��  ��   (  )�� ) l   ) )�� *��   * � �
		if the front window is not zoomed then
			set shouldZoom to true
		end if
		
		if the front window is not zoomable then
			set shouldZoom to true
		end if
		   ��    m      + +�null     � ��  �
iTunes.app  P� �0    ������� �0                 ��0�(.��� �)hook   alis    H  Locutus                    �3��H+    �
iTunes.app                                                      ���L?        ����  	                Media     �4@�      ��      �     %Locutus:Applications:Media:iTunes.app    
 i T u n e s . a p p    L o c u t u s  Applications/Media/iTunes.app   / ��  ��     ,�� , l      �� -��   - � �
if shouldZoom then
	tell application "System Events"
		tell process "iTunes"
			click menu item "Zoom" of menu "Window" of menu bar item "Window" of menu bar 1
			
		end tell
	end tell
end if
   ��       �� . /��   . ��
�� .aevtoappnull  �   � **** / �� 0���� 1 2��
�� .aevtoappnull  �   � **** 0 k     + 3 3  
����  ��  ��   1   2  +������
�� 
cwin
�� 
wshd
�� .miscactvnull��� ��� null�� ,� (*�k/�,e e*�k/�,FY f*�k/�,FO*j OPUascr  ��ޭ
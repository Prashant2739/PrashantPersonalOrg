<aura:application >
    <div id="myDIV" onclick="{!c.setActive}">
        <lightning:button class="btn" aura:id="bout" label="1"/>
        <lightning:button class="btn active" aura:id="bout" label="2"/>
        <lightning:button class="btn" aura:id="bout" label="3"/>
        <lightning:button class="btn" aura:id="bout" label="4"/>
    </div>
</aura:application>
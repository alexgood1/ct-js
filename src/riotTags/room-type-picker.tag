room-type-picker.room-editor-TypeSwatches.tabbed.tall
    .aSearchWrap
        input.inline(type="text" onkeyup="{fuseSearch}")
    .room-editor-aTypeSwatch(
        if="{!searchResults}"
        onclick="{parent.roomUnpickType}"
        class="{active: opts.current === -1}"
    )
        span {window.languageJSON.common.none}
        img(src="/img/nograph.png")
    .room-editor-aTypeSwatch(
        each="{type in (searchResults? searchResults : types)}"
        title="{type.name}"
        onclick="{selectType(type)}"
        class="{active: parent.opts.current === type}"
    )
        span {type.name}
        img(src="{type.graph === -1? '/img/nograph.png' : (glob.graphmap[type.graph].src.split('?')[0] + '_prev.png?' + getTypeGraphRevision(type))}")
    .room-editor-aTypeSwatch.filler
    .room-editor-aTypeSwatch.filler
    .room-editor-aTypeSwatch.filler
    .room-editor-aTypeSwatch.filler
    .room-editor-aTypeSwatch.filler
    .room-editor-aTypeSwatch.filler
    .room-editor-aTypeSwatch.filler
    
    script.
        this.namespace = 'roomview';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);
        
        this.getTypeGraphRevision = type => window.glob.graphmap[type.graph].g.lastmod;

        this.updateTypeList = () => {
            this.types = [...window.currentProject.types];
            this.types.sort((a, b) => a.name.localeCompare(b.name));
        };
        this.updateTypeList();
        window.signals.on('typesChanged', this.updateTypeList);
        const fuseOptions = {
            shouldSort: true,
            tokenize: true,
            threshold: 0.5,
            location: 0,
            distance: 100,
            maxPatternLength: 32,
            minMatchCharLength: 1,
            keys: ['name']
        };
        const Fuse = require('fuse.js');
        this.fuseSearch = e => {
            if (e.target.value.trim()) {
                var fuse = new Fuse(this.types, fuseOptions);
                this.searchResults = fuse.search(e.target.value.trim());
            } else {
                this.searchResults = null;
            }
        };
        this.selectType = type => e => {
            console.log(this.opts, type);
            this.parent.currentType = type;
            //this.parent.update();
        };
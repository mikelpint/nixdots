_: {
  nixpkgs = {
    overlays = [
      (final: super: {
        boxtron = final.callPackage ./boxtron super;
        bufpool = final.callPackage ./bufpool super;
        drwl = final.callPackage ./drwl super;
        dwl = final.callPackage ./dwl super;
        krisp-patcher = final.callPackage ./krisp-patcher super;
        mew = final.callPackage ./mew super;
        rtcqs = final.callPackage ./rtcqs super;
        rtirq = final.callPackage ./rtirq super;
        widle = final.callPackage ./widle super;
        wlock = final.callPackage ./wlock super;
      })
    ];
  };
}

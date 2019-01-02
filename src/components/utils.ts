export const findParent = (selector: string, el: HTMLElement): boolean => {
    let element: HTMLElement | null = el;
    let loops = 0;
    let found = false;
    const selectorArray = selector.split(' ');

    while (element !== null && loops < 30) {
        found = selectorArray.some((s: string, index: number, sArray: string[]) => {
            const hasId = element ? element.id === s : false;
            return hasId ? hasId : element ? element.classList.contains(s) : false;
        });
        if (found) {
            break;
        }
        element = element.parentElement;
        loops ++;
    }

    return found;
};

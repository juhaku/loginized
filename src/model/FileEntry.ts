export default class FileEntry {
  name: string;
  file: File;
  url: string;

  /**
   * Get name of this file without path if there is such defined.
   */
  public getFileName(): string {
    return this.name.substring(this.name.lastIndexOf("/") + 1);
  }
}
